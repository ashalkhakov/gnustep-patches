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
| `autoreleased-return-value` | libobjc2 | test | — | (none: ODataStore works around it) |
| `stack-block-retain` | libobjc2 | test | — | (none: ODataStore's vendored GCDWebServer works around it) |
| `predicate-equality-options` | libs-base | test | — | gnustep-coredata |
| `expression-self-type` | libs-base | test | — | gnustep-coredata |
| `expression-binary-coding` | libs-base | test | — | gnustep-coredata |
| `predicate-subquery` | libs-base | test | — | gnustep-coredata |
| `constant-expression-copy` | libs-base | test | — | (none: FreeCoreData's fix-managed-object-constants branch stops copying fetch predicates) |
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

Rechecked on 2026-09-26 against `libs-base` e835e21f5: every libs-base
patch applies and they co-apply. `dateformatter-cell-behavior` was
rebased on the way. Upstream cd90fbd3c made `-stringForObjectValue:` go
through `-stringFromDate:`, which fixes the formatting half, so the patch
now carries only the parsing half (`-getObjectValue:forString:errorDescription:`
still ignores the 10.4 behaviour) and the test. On unpatched master the
test's formatting checks pass and its parsing checks fail; patched, all 24
NSDateFormatter tests pass.

Added on 2026-09-26 against `libobjc2` aca3916: `autoreleased-return-value`.
With the runtime's own autorelease pool, `objc_retainAutoreleasedReturnValue()`
popped whatever same object sat on top of the pool, taking it for the
callee's autorelease; a synthesized nonatomic getter returns unretained, so
`*error = self.error; ... self.error ...` handed the caller an error the pool
no longer kept (found in ODataStore, where it freed an `NSError` and then
corrupted the heap). The new `Test/AutoreleasedReturnValue_arc.m` aborts
without the fix, in the plain and optimised builds, and the whole suite (200
tests) passes with it. libobjc2 registers tests in `Test/CMakeLists.txt`, so
unlike the libs-base ones this patch touches a build file. It is the first
libobjc2 fix here; `Scripts/build-gnustep.sh` now applies patches to
libobjc2 as it does to the others.

Added on 2026-09-26 against `libobjc2` aca3916: `stack-block-retain`.
`objc_retain()` copied a stack block to the heap and returned the copy, but
LLVM's ARC optimiser takes `objc_retain()` to return its argument, so with
optimisation on the copy went unused and unreleased, along with whatever it
captured. Any block parameter captured in another block (a completion
handler, `dispatch_async`) leaked this way once inlined; found in ODataStore,
where GCDWebServer leaked every connection and kept its socket open. The fix
returns a stack block unchanged, as Apple's runtime does; an explicit
`-retain` message still copies, since gnustep-base's block classes implement
it. The new `Test/StackBlockRetain_arc.m` fails in the optimised build
without the fix; with it the whole suite passes, 200 tests alone and 202
with `autoreleased-return-value`, which it co-applies with.

Added on 2026-09-26 against `libs-base` e835e21f5: `constant-expression-copy`.
Copying a constant expression copied its value, so copying any predicate
that compares with a value that cannot be copied raised, and Core Data
copies predicates: with `department == %@` and a managed object,
`-countForFetchRequest:error:` raised in FreeCoreData (found by
ODataStore). On macOS the copy shares the constant, a mutable one
included; the patch retains it instead. The new
`Tests/base/NSPredicate/constantCopy.m` fails six of its eight checks
without the fix and passes with it; `Tests/base/NSPredicate` (259 tests
with the other patches), `NSArray`, `NSSet` and `NSKeyedArchiver` pass.
All ten libs-base patches co-apply to that master with no fuzz.
FreeCoreData's own fix (a fetch request's copy shares its predicate, as
Apple's does) stands on its own, so nothing carries a copy of this one.

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
