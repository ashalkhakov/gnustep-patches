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

Pull requests opened on 2026-10-06, each a branch `fix/<name>` on
`ashalkhakov/<project>`, made with `git am` from the patch here.  Both
libobjc2 ones were closed unmerged within minutes by David Chisnall: "This
project does not accept code generated with LLMs."  The patches stay here
until another route upstream is settled.  `stack-block-retain` has since
left: libobjc2 fixed the same bug independently in fd475057c ("Fix memory
leak of block retained by another block", 2026-10-06) - the same early
return for a stack block in `retain()`, with its own `Test/BlockCapture_arc.m`
- and our patch no longer applies on top of it.  `sax-handler-calloc` was
merged as [#830](https://github.com/gnustep/libs-base/pull/830)
(434b1f806, 2026-10-06).  RDLKit, which the table listed as carrying it,
has no copy of its own: it applies this repository at a pinned commit, and
`apply-patches.sh` skips a patch that is already upstream.  Six more left on
2026-10-09, merged upstream: `urlprotocol-multipart-body`
([#833](https://github.com/gnustep/libs-base/pull/833), 2f1bf18,
2026-10-08), `expression-self-type`
([#810](https://github.com/gnustep/libs-base/pull/810), c788b60),
`bundle-load-and-return-error`
([#811](https://github.com/gnustep/libs-base/pull/811), 4458f49),
`constant-expression-copy` ([#812](https://github.com/gnustep/libs-base/pull/812),
a4453aa), `expression-function-names`
([#816](https://github.com/gnustep/libs-base/pull/816), da7c651) and
`keyedarchiver-secure-coding`
([#817](https://github.com/gnustep/libs-base/pull/817), d357cab).
`constant-expression-copy` was merged with a comment added beside the
changed line, so the patch neither applied nor reverse-applied and stopped
every build of libs-base from master; the other five reverse-apply.
gnustep-coredata, which the table listed as carrying two of them, has no
copy of its own either.

Fifteen more left on 2026-10-10, merged on 2026-10-09 and -10.  From
libs-base: `predicate-equality-options`
([#826](https://github.com/gnustep/libs-base/pull/826), 441eabe),
`dateformatter-cell-behavior`
([#813](https://github.com/gnustep/libs-base/pull/813), b7e4f0c),
`nsxmlelement-addattribute-value-doc`
([#822](https://github.com/gnustep/libs-base/pull/822), de027d0),
`nsxmlnode-string-value-escaping`
([#825](https://github.com/gnustep/libs-base/pull/825), b51b670),
`nsxmlnode-attribute-prefix`
([#824](https://github.com/gnustep/libs-base/pull/824), 2933c29),
`sortdescriptor-nil-first`
([#831](https://github.com/gnustep/libs-base/pull/831), 29a6a76),
`nsxml-default-namespace`
([#820](https://github.com/gnustep/libs-base/pull/820), fda167a),
`nsxml-default-namespace-descendants`
([#819](https://github.com/gnustep/libs-base/pull/819), bd71b3b),
`decimal-plain-notation`
([#814](https://github.com/gnustep/libs-base/pull/814), 810b3e9),
`keyedunarchiver-non-archive`
([#818](https://github.com/gnustep/libs-base/pull/818), b779502),
`urlprotocol-relative-redirect`
([#834](https://github.com/gnustep/libs-base/pull/834), fd35e3a),
`predicate-matches-line-anchors`
([#828](https://github.com/gnustep/libs-base/pull/828), edefd35) and
`predicate-like-wildcards`
([#827](https://github.com/gnustep/libs-base/pull/827), 337ab07).  From
libs-gui: `tableau-expression-lifetime-test`
([#980](https://github.com/gnustep/libs-gui/pull/980), 1615b4e) and
`pdf-print-operation` ([#979](https://github.com/gnustep/libs-gui/pull/979),
2c1f6a2).  `nsxml-default-namespace` neither applied nor reverse-applied
after rfm's cleanup 075fae9b4, so it stopped every build of libs-base from
master; the other fourteen reverse-apply.  The same cleanup reformatted a
context line of `xmlns-attribute`, which was rebased onto master 6bf26da5b
with its diff otherwise unchanged.  gnustep-coredata, GSXFormsKit
(XFormsKit) and RDLKit, which the table listed as carrying some of them,
apply this repository at a pinned commit and hold no copy.

Two more left later on 2026-10-10: `xmlns-attribute`
([#835](https://github.com/gnustep/libs-base/pull/835), 0d5151b) and
`string-diacritic-insensitive-search`
([#832](https://github.com/gnustep/libs-base/pull/832), 2f74d2e), both
tidied by rfm on the way in (f308d3c, 2ec74fe), so neither patch applied
or reverse-applied any longer.  RDLKit, listed for `xmlns-attribute`,
holds no copy.  The same day #815 and #977 were revised for their
reviews: #815's test now builds its predicate in code, since the parser
reads `$x.age` only with #829, and #977 names its keys with
`NSSelectionIndexesBinding` and `NSContentBinding`.  Both were checked
both ways in a fresh container: #815's test aborts at the first archive
without the fix and passes 9 of 9 with it alone (NSPredicate 289 of
289); #977's fails 8 of 9 without and passes with it (NSArrayController
38 of 38).  Both were merged that afternoon,
[#815](https://github.com/gnustep/libs-base/pull/815) (e18f0be) and
[#977](https://github.com/gnustep/libs-gui/pull/977) (19f2bbf), and have
left: #977 reverse-applies, and #815 stopped reverse-applying at the
commit after it.  gnustep-coredata, listed for both, holds no copy.

`action-sender-lifetime` ([#976](https://github.com/gnustep/libs-gui/pull/976))
was withdrawn on 2026-10-10.  Fred agreed the change was correct but asked
for a specific reason to retain at those two places, and XFormsKit, which
needed it, has kept retired controls alive until the event ends since
ad30625.  One path there still frees the sending control during its own
action, a `replace="all"` submission, and is
[XFormsKit#30](https://github.com/ashalkhakov/XFormsKit/issues/30).
XFormsKit should fix that before moving its gnustep-patches pin past the
commit that removes this patch.  It did:
[XFormsKit#31](https://github.com/ashalkhakov/XFormsKit/pull/31), merged on
2026-10-12, closes #30.

`predicate-subquery` ([#829](https://github.com/gnustep/libs-base/pull/829))
was merged on 2026-10-10 (aac55d9) and has left; gnustep-coredata, listed
for it, holds no copy.  The same day `predicate-secure-coding` was added
for [#766](https://github.com/gnustep/libs-base/issues/766): NSSecureCoding
and -allowEvaluation for predicates and expressions, matched against what
macOS does.  It and `selector-and-fetch-expressions` both edit how a key
path and a function are decoded, so the latter was rebased onto it, with
only those lines changed.  The selector-function and fetch expressions it
adds are not yet readable with secure coding (their strings are not in
an allowed set), which wants doing before that patch goes upstream.

`addnamespace-duplicate-prefix-leak`
([#838](https://github.com/gnustep/libs-base/pull/838)) was merged on
2026-10-10 as 85d1ada, unchanged, and has left.  On 2026-10-11 two more left:
`nsxmlelement-attribute-private-doc`
([#823](https://github.com/gnustep/libs-base/pull/823), d1498c1) and
`nsxml-prefixed-descendants` ([#821](https://github.com/gnustep/libs-base/pull/821),
3bd9327).  rfm merged #821 with its second case (two attributes with the
same prefix on a grandchild) failing on his system, and marked it hopeful
in 96fd936, so that patch neither applied nor reverse-applied any longer
and stopped every build of libs-base from master.  The failing case is
real with libxml2 2.15.4, which Debian testing ships, and not with 2.9.14,
which our images use: adoption declares a second href-less placeholder
under a made-up prefix (b_1).  `nsxml-placeholder-attributes`
([#839](https://github.com/gnustep/libs-base/pull/839)) fixes it and makes
the case count again.  rfm merged it on 2026-10-11 (d7cdfb0), unchanged,
and it has left.

Ten more were sent on 2026-10-12, each proven alone on that day's
master (libs-base dd82338, libs-gui f4cb83f): its test fails without it
and passes with it, with no other patch from here applied, and every
pair applies in either order.  #843 is `selector-and-fetch-expressions`
as it is against master; the copy here is rebased onto
`predicate-secure-coding`, which is not being sent yet, and differs from
it only in the two decoding lines they share.  The test of #844
(`predicate-format-expression-arguments`) used FUNCTION(), which only
#843 parses, so it now uses uppercase:() for the same check, which macOS
answers the same way.

Later on 2026-10-11 `tracking-walk-retains-subviews`
([#983](https://github.com/gnustep/libs-gui/pull/983), a8bdf74) left: it
was merged, and `apply-patches.sh` was already skipping it as upstream.  The
same day two NSCollectionView fixes were added, found by SimpleNotes
(TopoText), whose gallery and attachments browser are collection views with
a data source and a flow layout.  `collectionview-make-item`:
`-makeItemWithIdentifier:forIndexPath:` asked the data source instead of
making an item, so a data source that calls it, as AppKit documents,
recursed until the stack ran out.  `collectionview-flow-layout`: the flow
layout put items a width apart with no spacing, gave every item past the
first line a line of its own, and reported the view's frame as the content
size; and the layout attributes' factory methods returned nil.  Each test
was run both ways on libs-gui master 94a07bf in a container: `makeItem.m`
fails 2 of 4 without its fix, `lines.m` fails 10 of 10 without its; with
both, the NSCollectionView, NSCollectionViewItem and
NSCollectionViewFlowLayout suites pass 75 of 75.

On 2026-10-12 `font-substitution-by-name` was added, found by SimpleNotes'
AppImage, whose menus were slow to open on a desktop with many fonts.
`-fixFontAttributeInRange:` converted the assigned font to the family name
of the descriptor fontconfig matched (`-convertFont:toFace:` takes a font
name), so the conversion failed: characters the font lacks (Eau's ⌘ ⇧ ⌥ in
Liberation Sans) were never substituted, and each one drawn ran the failed
lookup again, a fontconfig sort over every installed font once
GershwinBehaviors' `+fontWithName:size:` falls back to matching
descriptors. The test was run both ways in a container on the stack
TopoText builds (libs-gui 94a07bf with this repository's patches):
`fontSubstitution.m` fails 1 of 2 without the fix, passes 2 of 2 with it.
Upstream master f4cb83f still has the bug.

The same day `textview-attachment-double-click` was added, also found by
SimpleNotes, whose file attachments open on a double click and did nothing
on Linux. `-[NSTextView mouseDown:]` gives an attachment's cell only the
first click, and the cell is what sends the delegate
`-textView:doubleClickedOnCell:inRect:atIndex:`, on the second; a double
click now reaches the cell when the delegate takes one. `attachmentDoubleClick.m`
fails 1 of 2 without the fix; with it, the NSTextView suite passes 57 of 57
(same stack as above). Upstream master f4cb83f still has the bug.

Later on 2026-10-12 `splitview-set-position-did-resize` was added, found
by SimpleNotes, which keeps its window's pane widths for the next launch
from its split view's `-splitViewDidResizeSubviews:`.
`-setPosition:ofDividerAtIndex:` posted the will-resize notification but
never the did-resize one (macOS posts both; so do a drag and
`-adjustSubviews` here), so a divider moved by a program went unseen.
`resizeNotification.m` gains a check that fails without the fix; with it,
the NSSplitView suite passes 20 of 20 (same stack as above). Upstream
master f4cb83f still has the bug.

On 2026-10-13 libs-base merged #843 (a588655), and the stack could no
longer be built from scratch: `selector-and-fetch-expressions`, merged in a
slightly different form, neither applied nor reverse-applied, and
`predicate-secure-coding`, which edits the same decoders, no longer applied.
`selector-and-fetch-expressions` left (gnustep-coredata, which the table
listed as carrying it, holds no copy: it took the fix through its pin). `predicate-secure-coding`
was rebased onto a588655, and the decoders #843 added (a function's operand,
a key path's target, a fetch request expression's request and context) now
decode as securely as the rest. `font-substitution-by-name` left too, merged
as libs-gui #1003. And `arc4random-glibc` was added: glibc before 2.36 has
no arc4random(), arc4random_uniform() or arc4random_buf(), which apps
written for Apple's C library call, so on Ubuntu 22.04 (where AppImages are
built, to run on older systems) HomeRow, UDCalc and ODataKit's Workbench
failed to link; the base library now declares and provides them there.
Checked on Ubuntu 22.04 (glibc 2.35), the stack built from scratch with
every patch at libs-base a588655 and libs-gui 311db7d: the NSPredicate and
Functions suites pass 619 of 619; `arc4random.m` fails to build without its
fix and passes 5 of 5 with it.

Later on 2026-10-13 libs-gui merged #984 (fdc5cfe) as it was sent, and
`xib-date-picker` left: on libs-gui master it reverse-applies whole, so
`apply-patches.sh` was already skipping it. The other nine libs-gui patches
apply to fdc5cfe.

The same day libs-base merged #847 (fbfc2da) as it was sent, and
`plist-read-binary` left. A follow-up upstream (62aeadc, "fix uninitialised
variable") then changed the same test, so on master the patch neither
applied nor reverse-applied, and it stopped every build of the stack from
scratch (UDQuakeTools' first, which had no cached stack). The other five
libs-base patches apply to 62aeadc.

Gershwin merges only into `dev`, never `main`, so its patches here are made
against `dev` and `Scripts/build-gnustep.sh` builds Eau from it, at a pinned
commit (`EAU_REF`, 01be00b since 2026-10-08): a change on `dev` broke every
build once, and a pin is moved on purpose.  Both Eau
pull requests were opened against `main` and closed on 2026-10-07:
`keep-nib-textfield-bezel` (#62) was brought onto `dev` by the maintainer as
#64, with its authorship kept and one conflict resolved; `nsalert-window-ownership`
(#63) has left, because `dev` fixed the same ownership bug itself, handing
`_window` its own +1.  `keep-nib-textfield-bezel` left on 2026-10-08: #64
merged, and `dev`'s 01be00b then took the initializers' default away
altogether (a field keeps its bezel unless the application makes it
non-editable), so the patch neither applied nor reverse-applied and stopped
every build of Eau.  No Eau patch is carried now.

A consumer that moves its pin past 8ec8484 has to build Eau from `dev`
(`git clone -b dev ...`) at the same time: that is the branch Gershwin
maintains, and the one any Eau patch here is made against.  FreeCoreData and
gnustep-coredata apply the Eau patches and need this.  HomeRow, NativeORM2,
RDLKit, UDQuakeTools and XFormsKit clone Eau without patches, so for them
`dev` is only the branch Gershwin actually maintains.  gnustep-build is not
in use.

`predicate-format-expression-arguments`, `predicate-nil-constant-format`
and `predicate-format-nil-arguments` left on 2026-10-14: rfm merged
[#844](https://github.com/gnustep/libs-base/pull/844) (78a1bb2),
[#845](https://github.com/gnustep/libs-base/pull/845) (e88c4a0) and
[#846](https://github.com/gnustep/libs-base/pull/846) (e9ff11d), with their
tests in his style, and the copies here reverse-apply to that master.
Before they left, the copies here were the older revisions, which neither
applied nor reverse-applied, and stopped every build of the stack.
gnustep-coredata (now FreeCoreData), listed for two of them, holds no copy.

Added on 2026-10-17 for UDCodeKit's jump-to-line box
([UDCodeKit#43](https://github.com/ashalkhakov/UDCodeKit/issues/43)):
`view-overlapping-siblings`.  A view laid over a sibling (a box over a
scroll view's text) was painted over whenever the sibling redrew:
invalidation marked a view's ancestors but no sibling stacked above it.
Scrolling was not the cause; with copiesOnScroll on or off, small scrolls
leave the box intact.  The overlapping part of each sibling above is now
marked too, on the sibling itself so that it is drawn after what is under
it.  macOS composites a layer per view instead, so there nothing is drawn
again.  `NSView/overlappingSiblings.m` fails 2 of its 4 checks without the
fix and passes with it; the whole gui suite (4896) passes on libs-gui
fdc5cfe.

Added on 2026-10-17 for [#24](https://github.com/ashalkhakov/gnustep-patches/issues/24):
`urlsession-lowercase-location`.  NSURLSession followed a 3xx response
only when its Location header was spelled that way, since the response
headers were gathered in a case-sensitive dictionary; HTTP/2 sends header
names in lower case, so over HTTP/2 no redirect was followed and a
download task finished with no file.  The headers now go into the
case-insensitive dictionary the request headers already use.  A new route
in `simpleTaskTests.m` redirects with a lower-case `location`; downloading
through it fails 6 checks without the fix and passes with it, and the
NSURLSession tests pass 147 of 147 on libs-base a767a16.

Added on 2026-10-17 for [#27](https://github.com/ashalkhakov/gnustep-patches/issues/27):
`tooltip-mouse-moved`.  A pending tooltip turned its window's
acceptsMouseMovedEvents on and, when it ended, off again if it had been
off, so a view that turned the flag on in between (a text view showing
hovers) lost its mouseMoved: after the pointer crossed any view with a
tooltip.  The window now sends mouse movements to a pending or shown
tooltip whatever the flag says, and tooltips leave the flag alone, as on
macOS.  `NSWindow/toolTipMouseMoved.m` fails its 3 checks without the fix
and passes with it; NSWindow (37), NSView and the NSMatrix and NSTabView
tooltip tests pass, on libs-gui fdc5cfe.

Added on 2026-10-17 for [#26](https://github.com/ashalkhakov/gnustep-patches/issues/26):
`tableview-prototype-copy`.  -makeViewWithIdentifier:owner: (and the
view a column falls back on) made each view from its prototype with
-copy, which for a view is shallow: no subviews, and outlets still into
the prototype, so a view-based table's rows were empty and text set
through textField went to the prototype.  Each view is now archived from
the prototype and unarchived anew, with the prototype's identifier.
`NSTableView/makeViewWithIdentifier.m` fails 5 of its 6 checks without the
fix and passes with it on libs-gui fdc5cfe; with `tableview-prototype-identifier`
as well, a xib loaded through NSNib gives each row its own text field.

Added on 2026-10-17 for [#25](https://github.com/ashalkhakov/gnustep-patches/issues/25):
`popover-placement`.  NSPopover converted its positioning rect as though
it were in window coordinates, exchanged the X and Y edges, forced a dark
grey background, and used its freed window when shown again after a close
(the window released itself when closed).  It now converts the rect from
the positioning view, sits beside the edge asked for (flipped views
respected), keeps and later releases its window, and leaves the background
alone.  `NSPopover/show.m`: without the fix the first check fails and the
second showing crashes, and with a fresh popover each time all 6 checks
fail; with it they pass, on libs-gui fdc5cfe.  The issue's third point,
that a popover takes the keyboard, did not reproduce here: the panel cannot
become key, and under Xvfb with no window manager the parent stays key.

Added on 2026-10-17 for UDQuakeTools' GUI editor: `opengl-view-hidden`.
On X an NSOpenGLView draws into an X window of its own over the view's,
and hiding the view (or a view it is in) left that window up, over what
was shown in its place.  A hidden view now clears its context's drawable;
drawing again then raised, since -_lockFocusInContext:inRect: made the
context current before giving it the view, which it now does first.
`NSOpenGLView/hidden.m` fails 3 of its 6 checks without the fix and
passes with it on libs-gui fdc5cfe, under Xvfb with Mesa's GLX.

| Fix | Upstream | Test | PR | Carried by |
| --- | --- | --- | --- | --- |
| `autoreleased-return-value` | libobjc2 | test | [#426](https://github.com/gnustep/libobjc2/pull/426) closed unmerged | (none: ODataStore works around it) |
| `urlsession-lowercase-location` | libs-base | test | not sent yet | (none: UDCodeKit follows 3xx itself) |
| `predicate-secure-coding` | libs-base | test | not sent yet ([#766](https://github.com/gnustep/libs-base/issues/766)) | (none: FreeCoreData will use it from here) |
| `arc4random-glibc` | libs-base | test | not sent yet | (none: every app built on the stack uses it from here; HomeRow's and UDCalc's shims are gone) |
| `collection-copy-is-shallow` | libs-base | test | not sent yet | (none: FreeCoreData uses it from here) |
| `nonretained-value-identity` | libs-base | test | not sent yet | (none: ORMKit uses it from here) |
| `xml-detached-namespaces` | libs-base | test | not sent yet | (none: ORMKit uses it from here) |
| `xml-remove-namespace-in-use` | libs-base | test | not sent yet | (none: ORMKit uses it from here) |
| `popover-placement` | libs-gui | test | not sent yet | (none: UDCodeKit places its own child windows meanwhile) |
| `tableview-prototype-copy` | libs-gui | test | not sent yet | (none: UDCodeKit's issues navigator is cell-based meanwhile) |
| `tooltip-mouse-moved` | libs-gui | test | not sent yet | (none: UDCodeKit resets the flag itself) |
| `view-overlapping-siblings` | libs-gui | test | not sent yet | (none: UDCodeKit's jump-to-line box needs it, ashalkhakov/UDCodeKit#43) |
| `opengl-view-hidden` | libs-gui | test | not sent yet | (none: UDQuakeTools' GUI editor uses it from here; its workaround is gone) |
| `tableview-column-autoresizing-style` | libs-gui | test | [#982](https://github.com/gnustep/libs-gui/pull/982) | gnustep-coredata |
| `collectionview-make-item` | libs-gui | test | [#1001](https://github.com/gnustep/libs-gui/pull/1001) | (none: TopoText uses it from here) |
| `collectionview-flow-layout` | libs-gui | test | [#1002](https://github.com/gnustep/libs-gui/pull/1002) | (none: TopoText uses it from here) |
| `textview-attachment-double-click` | libs-gui | test | [#1004](https://github.com/gnustep/libs-gui/pull/1004) | (none: TopoText uses it from here) |
| `splitview-set-position-did-resize` | libs-gui | test | not sent yet | (none: TopoText uses it from here) |
| `graphicscontext-backend-recursion` | libs-gui | program | [#978](https://github.com/gnustep/libs-gui/pull/978) | RDLKit |
| `tableview-bound-value-transform` | libs-gui | test | [#981](https://github.com/gnustep/libs-gui/pull/981) | (none: WorkflowKit uses it from here) |
| `tableview-prototype-identifier` | libs-gui | test | [#1005](https://github.com/gnustep/libs-gui/pull/1005) | (none: UDCalc will use it from here) |
| `scrollview-autohide-reentrancy` | libs-gui | test | not sent yet | (none: UDCalc will use it from here; Gershwin needs its own copy, see NOTES.md) |
| `layoutmanager-sanity-checks` | libs-gui | test | not sent yet | (none: UDCodeKit uses it from here) |
| `layoutmanager-layout-to-point` | libs-gui | test | not sent yet | (none: UDCodeKit uses it from here) |
| `textfield-binding-placeholders` | libs-gui | test | not sent yet | (none: UDQuakeTools uses it from here) |
| `quick-click-order` | libs-back | test | not sent yet | (none: UDCodeKit and UDQuakeTools use it from here) |
| `binding-to-many-mutation` | libs-gui | test | not sent yet | (none: UDQuakeTools uses it from here) |
| `cgrectunion-size` | libs-opal | none | [#71](https://github.com/gnustep/libs-opal/pull/71) | GSXFormsKit |
| `freetype-advance-without-size` | libs-opal | test | [#72](https://github.com/gnustep/libs-opal/pull/72) | (none: XFormsKit uses it from here) |
| `cfstring-overrelease` | libs-corebase | none | [#166](https://github.com/gnustep/libs-corebase/pull/166) | gnustep-build |
| `gsunicode-write-name` | libs-corebase | none (a compile error on Windows; the Windows stack build is the check) | not sent yet | (none: the Windows stack uses it from here) |
| `mingw-mode-t` | libdispatch | none (a header that does not compile on MinGW; the Windows stack build is the check) | not sent yet | (none: the Windows stack uses it from here) |
| `mingw-blocksruntime-name` | libdispatch | none (libdispatch.dll does not load on MinGW; the Windows stack check is the test) | not sent yet | (none: the Windows stack uses it from here) |
| `windows-listening-socket-read` | libdispatch | none (GCDWebServer's Windows smoke test is the check: it listens but never accepts without it) | not sent yet | (none: the Windows stack uses it from here) |

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

Rechecked on 2026-09-29 against fresh clones of every upstream master:
`libobjc2` aca3916, `libs-base` e0d966983, `libs-gui` ff49ac830,
`libs-opal` c4502a1, `libs-corebase` e89ff1f and `gershwin-eau-theme`
3d741fb. Every patch applies with no fuzz and none reverse-applies, and
the commits upstream since the last check (libs-base's `GSIsBlock()` and
NSTask signal masks, libs-opal's OpenBSD `swap64`) touch nothing the
patches fix.

Added on 2026-09-29 against `libs-base` e0d966983, all three found while
building ODataStore's predicate translation, and checked against macOS:

- `expression-function-names`: OS X names the arithmetic operators
  `add:to:`, `from:subtract:`, `multiply:by:`, `divide:by:` and
  `raise:toPower:` (and has `modulus:by:`); here only `_add` and its kin
  were known, so building one by the documented name raised and an OS X
  archive of `a + b` could not be read. The patch takes both, has the
  parser produce OS X's (so `-function` and archives agree with OS X),
  and adds `modulus:by:`. `arithmeticFunctionNames.m` aborts without it
  (the first check raises) and its 19 checks pass with it.
- `predicate-matches-line-anchors`: `^` and `$` in MATCHES match at each
  line on OS X (`UREGEX_MULTILINE`). `matchesLineAnchors.m`: four of its
  eight checks fail without the fix; all pass with it.
- `predicate-like-wildcards`: LIKE left every regular expression character
  but `*` and `?` live (`.`, `+`, `|`, brackets, `(`, which failed to
  compile) and took `?` as zero or one character. On OS X only `*`, `?`
  (exactly one) and a backslash escape mean anything. `likeWildcards.m`:
  nine of its sixteen checks fail without the fix; all pass with it, and
  every check was confirmed on macOS first.

With all nineteen libs-base patches, `Tests/base/NSPredicate` passes 293
tests, and `NSKeyedArchiver`, `NSArray`, `NSSet`, `NSString` and
`NSRegularExpression` pass; ODataStore's suite passes on the result.

Added on 2026-10-02 against `libs-base` 2e5067f8e:
`nsxml-default-namespace-descendants`. An element made with
`-initWithName:URI:` and given children while detached, then added under
an ancestor declaring that URI as the default namespace, printed
`xmlns="uri"` on every element below it, and a detached tree printed one
on every element; Apple's Foundation declares no namespace it was not
given (found by WorkflowKit's designer writing DMN). With libxml2 before
2.12, adoption declared the namespace on each child because the parent's
own was only a placeholder in its document; the fix lets adoption map
the child to that placeholder instead. `defaultNamespaceDescendants.m`
fails two of its six checks without the fix and passes with it;
`NSXMLElement` (147), `NSXMLNode` (266) and `NSXMLDocument` (39) pass
with all 25 libs-base patches, which apply to that master in order with
no fuzz. The patch applies to master on its own as well.

Added on 2026-10-07 against `libs-base` e6de7b7db:
`predicate-format-expression-arguments`. Given an `NSExpression` for `%@`,
`+expressionWithFormat:` and `+predicateWithFormat:` wrapped it in a
constant, where Apple's Foundation uses the expression itself - so an
inferred mapping's `FUNCTION($manager, ..., %@)` handed the migration
manager an expression object instead of the related objects (found by
FreeCoreData, which now builds that expression rather than formatting it).
`expressionArguments.m` fails seven of its ten checks without the fix and
passes with it, and Apple's Foundation gives all ten the same answers;
`NSPredicate` (335) passes with all libs-base patches, which apply to that
master in order with no fuzz. Two neighbouring differences from Apple are
not fixed here: an expression substituted for a `$variable` is wrapped as a
constant too, and an aggregate literal `{a, b}` parses as a constant array
whose `-collection` raises.

Added on 2026-10-07 against `libs-base` e6de7b7db:
`predicate-nil-constant-format`. A constant expression whose value is nil
or `NSNull` printed as `(null)` or `<null>`, which no parser reads back, so
`title != nil` came out as `title != <null>` and a model saved on GNUstep
with a fetch request or partial index comparing with nil could not be
compiled again (found by FreeCoreData's fetch index round trip). Apple's
Foundation prints nil; this one parses nil to `NSNull`, so `NSNull` prints
as nil too. `nilConstant.m` fails three of its six checks without the fix,
its set stopping where the format does not parse back, and passes with it;
`NSPredicate` (341) passes with all libs-base patches applied in order.
Apple also prints `==` where this one prints `=`, and spells a function
call's arguments in one pair of parentheses where this one uses two; both
still parse, and are left alone.

Added on 2026-10-08 against `libs-base` 2f1bf18:
`predicate-format-nil-arguments`. `+predicateWithFormat:` and
`+expressionWithFormat:` gather their variadic arguments into an array
before parsing, so a nil object argument raised "Tried to add nil to array"
and `owner == %@` could not be made for no owner (found by SimpleNotes'
per-user notebooks, whose server compares with the signed-in user, nil for
an anonymous request). Apple's Foundation compares with nil; a nil argument
is now the `NSNull` constant the literal `nil` already parses to, and the
arguments after it keep their places. `nilArguments.m` fails eight of its
ten checks without the fix and passes with it; `NSPredicate` (351) passes
with all libs-base patches applied in order.

Added on 2026-10-08 against `libs-base` 2f1bf18: `plist-read-binary`.
`-initWithContentsOfFile:` and `-initWithContentsOfURL:` of `NSDictionary`
and `NSArray` read the file as an `NSString` and called `-propertyList`,
which parses the text formats only, so a binary property list (what
Apple's Foundation, and `NSPropertyListSerialization` here, write by
default) was "not string data using Unicode (UTF-8)" and came back nil.
Found by SimpleNotes on Linux: it kept a signed-in user's tokens in a
binary property list and never read them back. They read the data and
parse it with `NSPropertyListSerialization` now; an array is still
returned mutable. `binaryPropertyLists.m` fails five of its ten checks
without the fix; `NSDictionary` (143), `NSArray` (139),
`NSMutableDictionary` (68), `NSPropertyList` (29), `PropertyLists` (133)
and `NSUserDefaults` (94) pass with all libs-base patches applied in order.

Added on 2026-10-16 against `libs-base` e00f6dc: `collection-copy-is-shallow`.
`-copyWithZone:` of `NSSet`, `NSArray` and `NSOrderedSet` made the copy
with `copyItems: YES`, so copying a subclass of one of them copied every
member, and raised for a member that is not `NSCopying`.  Apple copies a
collection shallowly whatever its class, as `NSDictionary` here already
did.  Found by FreeCoreData
([#83](https://github.com/ashalkhakov/FreeCoreData/issues/83)): a to-many
relationship's value is a subclass of `NSMutableSet`, so key-value
observing, which copies the old set when members are removed, raised for
an observer that asks for old values.  `NSCountedSet` copies its members
too, and is left as it is: nothing found it.  Each new `copySubclass.m`
fails both its checks without the fix; `NSSet` (130), `NSArray` (141),
`NSOrderedSet` (960), `NSPredicate` (386) and `NSKVOSupport` (518) pass
with all libs-base patches applied in order, and the whole base suite
passes but for `GSMime/encoded-word-stack.m`, which aborts without the
patch too.

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

A third, still open on libs-base 2ec74fecb: `XMLStringCopy` in
`Source/NSXMLPrivate.h` allocates with plain `malloc` the strings it hands
to libxml2 (a document's version and encoding, a DTD's ids, an entity's
name), and libxml2 frees them with `xmlFree`.  Harmless while `xmlFree` is
`free`; it corrupts the heap of any program that installs its own allocator
with `xmlMemSetup`.  `xmlMalloc`/`xmlStrdup` would be the fix.  The analysis
is in `libs-base/xmlns-attribute/NOTES.md` as of 34b5f2b, retired with that fix.

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

None remain.  `action-sender-lifetime` and `tracking-walk-retains-subviews`
used to exist byte-for-byte in XFormsKit (GSXFormsKit) and HomeRow; as of
2026-10-10 neither repository holds a copy of either.
