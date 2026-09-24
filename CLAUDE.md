# Working in this repository

This is where GNUstep fixes live until they are upstream. Several projects
used to carry their own copies; they consume this one instead. If you are
about to add a `.patch` to another repository, add it here and have that
repository apply it from here.

## The shape of a fix

One directory per fix, under the upstream project it belongs to:

```
<upstream-project>/<fix>/0001-<fix>.patch   a complete commit: subject, body, diff
<upstream-project>/<fix>/<repro>.m         only when no test is possible
<upstream-project>/<fix>/NOTES.md          only when there is more to say
```

The patch is a mailbox-format commit, not a bare diff, because the unit of
upstreaming is a branch:

```sh
git checkout -b fix/<name> master
git am /path/to/gnustep-patches/<project>/<fix>/0001-*.patch
git push fork fix/<name>
```

Record the pull request in `STATUS.md`. When it merges, delete the fix from
here *and* from every repository the table lists as carrying a copy, in the
same pass.

## Writing one

**The reasoning goes in the commit message, not in comments.** Maintainers
read the message once and then want the diff to show the change; a patch
that adds several lines of narrative beside each changed line is a patch
that gets asked to shrink. Keep at most a single short line where the code
alone would baffle a reader. This is the opposite of the house style in our
own repositories, and the difference is the audience.

**Ship the test in the same commit.** Both libs-base and libs-gui have their
own suites — `Tests/base/<Class>/*.m` and `Tests/gui/<Class>/*.m`, run by
`gnustep-tests`, using `PASS(...)`, `PASS_EQUAL(...)`, `START_SET`/`END_SET`.
A patch that adds a failing-before test in the maintainer's own harness is a
much easier yes than one that points at a program in another repository.
Adding a file needs no build-file change; the harness discovers it.

**Prove the test both ways.** A test that passes with and without the fix is
worse than no test. Revert the source file in a built checkout, rebuild,
run, and see it fail; restore, rebuild, run, and see it pass. Where that is
impossible — a use-after-free the allocator hides, a fault only valgrind
sees, a fixture only Interface Builder can produce — keep the reproduction
program instead and say in the commit message why there is no test.

**Check whether the bug is still there, not just whether the patch applies.**
A patch can apply cleanly to a project that has already fixed the bug
another way, because it is a different edit to the same area. That happened
here: `2db1f1802` fixed the tableau expression lifetime upstream while our
patch still applied on top. Reverse-apply is the quick check
(`patch -p1 -F0 -R --dry-run`, and `-F0` matters — with its default fuzz,
`patch` will cheerfully report that an already-applied fix still applies).

## The test environment

GNUstep is built and tested in docker. The container `cdci` holds a built
stack; `docker ps -a | grep cdci` tells you whether it is still there.

```
/w/build                 the prefix: the whole GNUstep stack, installed
/w/dependencies/libs-*   source trees, patched and built - where you rebuild
/w/status/<project>      clean checkouts at upstream master - where you git am
/w/am/gnustep-patches    a copy of this repository, refreshed by you
/repo                    the host's gnustep-coredata, read-only
```

Copy this repository in before using it, since the container's copy goes
stale the moment you edit a patch:

```sh
cd /Volumes/ExtraSSD/Projects/gnustep-patches && tar cf - --exclude .git . \
  | docker exec -i cdci bash -lc 'rm -rf /w/am/gnustep-patches \
      && mkdir -p /w/am/gnustep-patches && tar xf - -C /w/am/gnustep-patches'
```

Apply, build, install and test:

```sh
docker exec cdci bash -lc '/w/am/gnustep-patches/Scripts/apply-patches.sh libs-base /w/dependencies/libs-base'
docker exec cdci bash -lc 'cd /w/dependencies/libs-base && . /w/build/System/Library/Makefiles/GNUstep.sh \
    && make -j4 && make install'
docker exec cdci bash -lc 'cd /w/dependencies/libs-base && . /w/build/System/Library/Makefiles/GNUstep.sh \
    && gnustep-tests Tests/base/NSPredicate'
```

Rebuilds are incremental, so reverting one source file and rebuilding costs a
compile and a link, not a stack. That is what makes proving a test both ways
cheap.

For libs-gui, wrap the run in `xvfb-run -a`. Tests that need a display use
the suite's own guard — `[NSApplication sharedApplication]` inside
`NS_DURING`, then `SKIP("No display available")` — so copy that shape from
`Tests/gui/NSMenu/performAction.m`.

## Traps, all of them met here

- `docker exec` without `-i` swallows stdin, so a heredoc or a pipe into it
  silently does nothing.
- A shell redirect runs even when the command before it fails:
  `docker exec cdci cat /tmp/x > patch` truncates `patch` when the container
  has no `/tmp/x`. Write to a temporary file, check it, then move it.
- `git am` needs a committer identity: export `GIT_COMMITTER_NAME` and
  `GIT_COMMITTER_EMAIL`, or every apply fails with "Committer identity
  unknown".
- `git checkout -B` fails on a dirty tree; `git reset --hard` and
  `git clean -fd` first, or you will apply a patch onto a previous one.
- `GNUstep.sh` reads `$ZSH_VERSION` unguarded, which is an error under
  `set -u`. Relax it around the source.
- In the test harness, `PASS(...)` is a macro, and the preprocessor splits
  on commas that square brackets do not protect. Any message send with two
  arguments inside `PASS` must be wrapped in its own parentheses.
- There is no valgrind in the image, so a fault only valgrind can see cannot
  be demonstrated there.
- The container is a pet, not a recipe: it was built by hand on `ubuntu:24.04`
  and the stack inside it is not in any image. `docker commit cdci` before
  doing anything drastic, or rebuild it with `Scripts/build-gnustep.sh`.
