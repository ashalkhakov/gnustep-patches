# Status

One row per fix.  A fix leaves this table only when its pull request is
merged *and* the patch has been deleted from every repository that carried a
copy — the last column is what that pass has to visit.

Checked on 2026-09-24 against `libs-base` a8dd1b817, `libs-gui` ff49ac830,
`libs-opal` 98f8e4f, `libs-corebase` e89ff1f and `gershwin-eau-theme`
3d741fb: every patch below applies to that master, with no fuzz, and the
patches for one project co-apply with each other.  The Opal patch was
regenerated in the process - the copy it came from no longer matched.

## Pending

| Fix | Upstream | Test | PR | Carried by |
| --- | --- | --- | --- | --- |
| `predicate-equality-options` | libs-base | test | — | gnustep-coredata |
| `expression-self-type` | libs-base | test | — | gnustep-coredata |
| `expression-binary-coding` | libs-base | test | — | gnustep-coredata |
| `predicate-subquery` | libs-base | test | — | gnustep-coredata |
| `dateformatter-cell-behavior` | libs-base | test | — | gnustep-coredata |
| `keyedarchiver-secure-coding` | libs-base | test | — | gnustep-coredata |
| `nsxmlelement-addattribute-value-doc` | libs-base | program | — | GSXFormsKit |
| `sax-handler-calloc` | libs-base | program | — | RDLKit |
| `xmlns-attribute` | libs-base | test | — | RDLKit |
| `arraycontroller-selection-kvo` | libs-gui | test | — | gnustep-coredata |
| `tableview-column-autoresizing-style` | libs-gui | test | — | gnustep-coredata |
| `xib-date-picker` | libs-gui | none | — | gnustep-coredata |
| `action-sender-lifetime` | libs-gui | test | — | GSXFormsKit, HomeRow |
| `tableau-expression-lifetime-test` | libs-gui | test only | — | (new: the fix is already upstream) |
| `tracking-walk-retains-subviews` | libs-gui | program | — | GSXFormsKit, HomeRow |
| `pdf-print-operation` | libs-gui | program | — | RDLKit |
| `graphicscontext-backend-recursion` | libs-gui | program | — | RDLKit |
| `cgrectunion-size` | libs-opal | none | — | GSXFormsKit |
| `cfstring-overrelease` | libs-corebase | none | — | gnustep-build |
| `keep-nib-textfield-bezel` | gershwin-eau-theme | none | — | gnustep-coredata |
| `nsalert-window-ownership` | gershwin-eau-theme | none | — | gnustep-build |

Re-run that check before sending anything: `Scripts/apply-patches.sh` on a
fresh checkout is the quickest form of it.

Where the column says **test**, the patch adds a test to the project's own
suite (`Tests/base/...`, run by `gnustep-tests`), so the fix and the thing
that proves it travel in one commit.  Each of those tests was checked both
ways: it passes with the patch and fails, or aborts, without it.

Where it says **program**, a standalone reproduction sits beside the patch
instead, and the commit says why: one needs the libxml2 headers to see a
dangling pointer, the other is only visible under valgrind.

Two of the gui fixes keep their reproduction programs rather than gaining
tests, and for a reason worth recording: a use-after-free is only a failure
when the allocator makes it one.  The action-sender case does fail
deterministically once the test drains the autorelease pool that would
otherwise keep the sender alive - that took a second look.  It still wants a
sanitizer build or a desktop to be worth asserting on.

The PDF one no longer does.  It was recorded here as unassertable because the
reproduction counted `/Type /Page` in the raw bytes and found none on this
system, patched or not - but the cairo backend writes its page objects into
FlateDecode streams, so there was nothing to find in the raw bytes and the
pages were there all along.  The reproduction inflates the streams now
(`-lz`, `-D_GNU_SOURCE`), and reports **three pages with the patch and one
without it**, checked both ways in the container on 2026-09-25 by reverting
`Source/GSPDFPrintOperation.m`, rebuilding and reinstalling.  That makes it a
candidate for a real test in `Tests/gui`, which would make it a much easier
yes upstream.

Writing the tests found one bug in the patches themselves: the secure-coding
patch called `+supportsSecureCoding` on a class that need not implement it,
so refusing a non-secure object aborted instead of reporting an error.  It
now asks whether the class responds first.

## Checked and not needed here

Gone through on 2026-09-25 while auditing what RDLKit still carries.  None of
these is a GNUstep bug; they are recorded so nobody else spends the afternoon:

| What | Where it belongs |
| --- | --- |
| `NSXMLDocument` drops a text node that is only whitespace | Apple's Foundation only.  GNUstep reads all five cases correctly - whitespace-only content, with and without `xml:space="preserve"` and `NSXMLNodePreserveWhitespace`, and text with a trailing space - checked with RDLKit's own reproduction in the container |
| `ibtool` aborts on three pieces of hand-written XIB markup | Xcode's `ibtool` only.  GNUstep's `GSXib5KeyedUnarchiver` loads all three - an `id` on `<tableHeaderCell>`, a `<splitView>` with no `<holdingPriorities>`, a `<tableHeaderView>` with no reference - and instantiates their top-level object |
| ~~`-[NSView dataWithPDFInsideRect:]` never returns on a headless machine~~ | **Wrong: it is real, and it is now `graphicscontext-backend-recursion` above.**  The first pass called it unreproducible because every reproduction written to show it made an `NSApplication` first, which is exactly what hides it.  Run the same code in a tool that makes none -- a report generator -- and it spins for ever |

That correction is the lesson of the pass: a reproduction written by hand
starts from the habits of the person writing it, and the missing
`sharedApplication` was one nobody would think to leave out.  Reproduce from
the program that actually failed where you can.

Two smaller things seen in passing, neither worth a patch on its own:
`GSXib5KeyedUnarchiver` warns "unknown border type: bezel" from
`-decodeScrollViewFlagsForElement:` and would warn the same for `groove` from
`-decodeBorderTypeForElement:` - each decoder is missing the case the other
has, and in both the fall-through happens to leave the value the markup asked
for, so it is a spurious warning rather than a wrong border.  And
`-[NSNib instantiateWithOwner:topLevelObjects:]` raises
`NSInvalidArgumentException` ("Tried to add nil value for key 'NSOwner'") for
a nil owner, which Cocoa accepts; that one wants checking against Cocoa with
a compiled nib before it is called a bug.

## Done, and still carried somewhere

These are fixed upstream.  The copies are dead weight and should be deleted
along with the lines that apply them.

| Fix | Upstream | What happened | Delete from |
| --- | --- | --- | --- |
| `tableview-selection-push` | libs-gui | merged; the patch reverse-applies to master | `gnustep-build/Scripts/patches/`, and its apply line in `Scripts/build-gnustep.sh` |
| `tableview-selection-push` (older draft) | libs-gui | superseded by the revision that merged; applies neither way now | `UDQuakeTools/Scripts/`, and the PENDING note in `Scripts/gnustep-patch-repros/README.md` |
| `gscstableau-removerow-use-after-free` | libs-gui | upstream fixed it in 2db1f1802 (retain at entry, release at exit, and the caller keeps its own reference); our patch adds a redundant line on top | `GSXFormsKit/patches/gnustep/`, `HomeRow/patches/gnustep/`, and their apply lines |
| `arraycontroller-selection-init` | libs-gui | master already initialises `_selection_indexes` in `-initWithCoder:`; only the explanatory comment differs | `gnustep-build/Scripts/patches/`, and its apply line |

## Duplicates to retire

`action-sender-lifetime` and `tracking-walk-retains-subviews` exist
byte-for-byte in both `GSXFormsKit` and `HomeRow` (as did
`gscstableau-removerow-use-after-free`, now superseded upstream).  HomeRow's README says they were copied unchanged and that it
does not knowingly depend on them.  Both should consume this repository
instead of holding copies.
