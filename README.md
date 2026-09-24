# gnustep-patches

Fixes to GNUstep and its neighbours, written while building applications on
top of them, held here until they are upstream.

Everything in this repository exists because several projects were each
carrying their own copy of the same thing: the same patches (three of them
byte-for-byte in two repositories, one in two revisions that had already
drifted apart), and the same few hundred lines of "build the GNUstep stack
from source" shell. One copy, consumed by all of them, is the point.

## Layout

```
<upstream-project>/<fix>/0001-<fix>.patch   a complete commit: subject, body, diff
<upstream-project>/<fix>/<repro>.m          a program that fails without it, where one exists
<upstream-project>/<fix>/NOTES.md           longer context, where there is any
STATUS.md                                   every fix, its state, and who carries a copy
Scripts/apply-patches.sh                    apply one project's patches to a checkout
```

The upstream projects are `libs-base`, `libs-gui`, `libs-opal`,
`libs-corebase` and `gershwin-eau-theme`.

Each patch is a mailbox-format commit rather than a bare diff, because the
unit of upstreaming is a branch, not a file. The subject and the rationale
are written for a maintainer who has never heard of the application the bug
was found in.

## Sending one upstream

Fork the project once, then per fix:

```sh
git checkout -b fix/predicate-equality-options master
git am /path/to/gnustep-patches/libs-base/predicate-equality-options/0001-*.patch
git push fork fix/predicate-equality-options
```

The commit message is already written. Attach the reproduction program to
the pull request, or better, port it to the project's own test suite first -
`libs-base` runs `Tests/base/<Class>/*.m` under `gnustep-tests`, and a pull
request that adds a failing-before test there is a much easier yes.

Record the pull request in [STATUS.md](STATUS.md). When it is merged, delete
the fix from this repository *and* from every repository the status table
lists as carrying a copy, in the same pass.

## Building the stack

`Scripts/build-gnustep.sh` builds a patched GNUstep from source into a
prefix. It replaces the near-identical `dependencies.sh` that four projects
were each carrying, where the differences that mattered were drowning in
differences that did not.

```sh
PREFIX=$PWD/build Scripts/build-gnustep.sh
COMPONENTS="libobjc2 libdispatch tools-make libs-base" \
    PREFIX=$PWD/build Scripts/build-gnustep.sh         # Foundation only
PREFIX=$PWD/build Scripts/build-gnustep.sh --verify-only
```

What a consumer chooses: `COMPONENTS` (the default is the full desktop
stack; a Foundation-only project builds four things and skips the rest),
`PATCHES` (`all`, `none`, or named topics), `PREFIX` and `SOURCES`, and a
`<COMPONENT>_REF` to pin one project to a commit.

What it decides for everyone, because the answer never actually differed:
libdispatch is built before gnustep-base with its private headers, so that
base's configure finds the main-queue hooks - build it afterwards and a
main-queue context's `-performBlock:` silently never runs; `--with-config-file`
is asked of gnustep-make rather than guessed; the backend gets its version
fallback symlinks; Opal builds `Source` only and gets its headers directory
created first; corebase gets the `-L` its Objective-C probe needs; the Eau
theme asks for `-lBlocksRuntime` only if there is one.

Every build ends in a `verify` pass - the dispatch hooks, ICU linkage, a
backend bundle - and `--verify-only` runs it against a prefix that came from
a cache, because a restored prefix can be wrong in exactly the same ways as
a fresh one.

In CI, use the recipe hash as the cache key so that editing a patch or
changing the component list invalidates the cache, which is the thing four
hand-maintained `hashFiles(...)` expressions kept getting wrong:

```yaml
- id: recipe
  run: echo "hash=$(gnustep-patches/Scripts/build-gnustep.sh --print-recipe-hash)" >> "$GITHUB_OUTPUT"
- uses: actions/cache/restore@v4
  with:
    path: ${{ env.PREFIX }}
    key: gnustep-${{ runner.os }}-${{ steps.recipe.outputs.hash }}
```

## Using the patches

To patch a checkout you already have:

```sh
Scripts/apply-patches.sh libs-base /path/to/libs-base
```

Patches apply with no fuzz, so a hunk that no longer matches is an error
rather than a guess. A patch that turns out to be already present is skipped
with a note - which is what a merged fix looks like in the window between
the merge and the deletion pass, and it must not break anyone's build.

## Checking a patch against today's upstream

```sh
git -C /path/to/libs-base checkout master && git pull
patch -p1 -F0 --dry-run -d /path/to/libs-base < libs-base/<fix>/0001-*.patch   # still needed
patch -p1 -F0 -R --dry-run -d /path/to/libs-base < libs-base/<fix>/0001-*.patch # already upstream
```

If the reverse dry-run succeeds, the fix has landed: delete it. If neither
succeeds, the patch has gone stale and needs rebasing before anyone sends
it. Do not use `patch` without `-F0` for this: with its default fuzz it
will cheerfully report that an already-applied fix still applies.
