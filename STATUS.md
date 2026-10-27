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

Added on 2026-10-19: `nsdate-tagged-roundtrip`, found by ORMKit, whose
`[NSDate dateWithTimeIntervalSinceReferenceDate: 0]` came out two seconds
late.  A small (tagged) date keeps an 8-bit exponent and was made from any
interval without checking that it fits, so every magnitude outside
[2^-144, 2^112) came back as another number: 0 as 2, -0.0 as -2, 5e-324 as
2.0000000000000004, DBL_MIN as 4, 1e-300 as 179769313.49, 1e300 as
5.6e-09, DBL_MAX as 0.99999999999999989, +-inf as +-1; isEqual:, compare:,
description and archiving all saw the wrong value.  Such intervals now go
into a heap date, as macOS falls back from __NSTaggedDate to __NSDate.
`NSDate/roundtrip.m` (a table at the encoding's edges and 200000 random
intervals, fixed seed) fails 8 of its 11 checks without the fix and passes
with it on libs-base 7b3a12c.  Not fixed here and seen on the way:
NSCalendarDate's -description never returns for |interval| >= about 1e25
(also for small dates, so on master too), and a small date's -hash is its
pointer, not the (NSUInteger)interval of NSDate's, so it differs from that
of an equal date of another class.

Added on 2026-10-19: `controller-selection-markers`.  A controller's
-selection was its content (NSObjectController) or the one selected object
or nil (NSArrayController), so selection.<key> was nil with nothing or
several selected and bound controls showed an empty value instead of the
"No Selection" and "Multiple Values" placeholders.  -selection now answers
a proxy, as on macOS 15: the selected objects' common value, else
NSMultipleValuesMarker (always for several, with
alwaysUsesMultipleValuesMarker), NSNoSelectionMarker with nothing selected,
NSNotApplicableMarker for a key they do not have (macOS raises there and
the binding substitutes it); setting through it sets every selected
object; observers of selection.<key> hear of changes to the selection and
to the selected objects.  `NSObjectController/selectionMarkers.m` fails 11
of its 17 checks without the fix and passes with it on libs-gui 5c43a947f;
`NSArrayController/selectionKVO.m`, which checked the old answers, now
checks these.

Amended on 2026-10-20, two regressions of the 2026.10.20 release.
`nsdateformatter-settings` made a formatter not lenient by default with
ICU's strict parsing, which refuses what macOS's not-lenient parsing
takes: ORMKit read NORMA's sample date "1900/01/01" with "yyyy-MM-dd".
macOS calls udat_setLenient(false) (strict calendar, no
UDAT_PARSE_ALLOW_WHITESPACE or UDAT_PARSE_ALLOW_NUMERIC) and leaves
UDAT_PARSE_PARTIAL_LITERAL_MATCH and UDAT_PARSE_MULTIPLE_PATTERNS_FOR_MATCH
on, as GNUstep did, but Apple's ICU then matches a separator of the
pattern with any run of the separators ICU ignores before the next field
(rdar://20692829 in its SimpleDateFormat::matchLiterals); ICU's does not.
A strict parse that fails at a literal now gets it as Apple's ICU would
match it and is tried again, and -dateFromString: no longer takes a
string with text after the date (macOS allows white space other than line
ends).  `NSDateFormatter/strictParsing.m`, macOS 15's answers for 159
formats and strings, strict and lenient, fails 247 of its 318 checks
without the patch and passes with it, on ICU 74 (Ubuntu 24.04) and 70
(22.04).
`controller-selection-markers` let markers reach bindings, which replaced
each with a "No Selection", "Multiple Values" or "Not Applicable" string
whatever the binding, so content bound through selection.<key> became a
string and Logbook's main window failed to load ("NSConstantString does
not recognize sortedArrayUsingDescriptors:").  The placeholder is now the
binding's option, else +defaultPlaceholderForMarker:withBinding: of the
bound object's class, implemented now, nil but for NSTextField's value, as
on macOS 15; content is then empty.  `NSObjectController/markerPlaceholders.m`
passes on macOS 15; without the patch 6 of its checks fail and its
default-placeholder set stops at the missing method.
Logbook's main window, as its working tree has it now, also binds pop-ups'
contentValues through a to-many (`drivers.lbTitle`), which raised here
("addObserver:forKeyPath:options:context: is not supported"): macOS
observes the to-many and each member.  `popup-content-bindings` now does
too; `NSPopUpButton/contentValuesKeyPath.m` passes on macOS 15 and fails
all 6 checks without the patch.  The NSDateFormatter, NSObjectController,
NSArrayController and NSPopUpButton tests pass, the whole base suite passes
14665 checks (encoded-word-stack.m aborts, as on master) and the gui suite
5199 with none failing, on libs-base d537eac and libs-gui 5c43a947f with every patch
here.

Added on 2026-10-20 for Logbook's main window, so that its self-test
passes with every check: `controller-to-many-content` and
`popup-selected-object`.  An array controller with content bound changed
only its own content array, so a record added to a vehicle's records
(bound through the vehicles' selection) got no vehicle and the binding
arranged it twice.  On macOS 15 adding, inserting and removing set a
changed copy of the bound to-many on the bound object (Core Data keeps
the inverse), arrange as for unbound content (an object already in the
to-many twice), insert into the content before the arranged object it goes
before unless sorted or filtered, and clear the filter on insertion
(`clearsFilterPredicateOnInsertion`, kept but unused here); all of that
now holds.  `NSArrayController/boundContentMutation.m` passes on macOS 15
and fails 16 of 23 checks without the patch.  A pop-up's selectedObject
(and selectedIndex, Tag, Value) took the chosen item only from the cell's
item action, and only once drawn; macOS takes it in -sendAction:to: and
from the menu, not from -selectItemAtIndex: alone, and
NSInsertsNullPlaceholderBindingOption on selectedObject adds the "No
Value" item (ignoring that binding's null title).
`NSPopUpButton/selectedObjectAction.m` passes on macOS 15 and fails 6 of
13 checks without the patch.  With both, Logbook's `make -k check` ends
"self-test done: 0 failed" on the 2026.10.20 image with every patch here;
the gui suite then passes 5235 checks with none failing and the base suite
14665 (encoded-word-stack.m aborts, as on master).

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

Added on 2026-10-19 for Logbook's controllers:
`arraycontroller-selection-kvo`.  NSArrayController's -addSelectedObjects:
and -removeSelectedObjects: read as the add<Key>: and remove<Key>: set
mutators of selectedObjects, and its selection setters as setters, though
all return BOOL and the first two take arrays.  Once anything observed
selectedObjects, gnustep-base's KVO swapped in a set mutation: an observer
with old and new values had -member: sent to an NSArray, so -addObject:
with selectsInsertedObjects raised, and the BOOLs returned were garbage.
macOS declines automatic notification for those keys and notifies itself
(checked on macOS 15); so does this now.  The fault is libs-gui's, not
gnustep-base's: the KVO follows the accessor naming patterns as macOS's
does.  `NSArrayController/selectionMutators.m` fails 10 of its 13 checks
without the fix and passes with it on libs-gui 5c43a947f.

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

Added on 2026-10-19 for Logbook's controllers:
`arraycontroller-arrange-eagerly`.  Unless it rearranged automatically,
NSArrayController dropped its arranged objects on each addition and
removal and arranged them again inside -arrangedObjects, which the first
observer to ask called from within the content's change notification; so
observers of arrangedObjects heard of each change twice, with the new
value as the old, and observers of arrangedObjects.<key> were left on
removed objects, which raised when those were deallocated.  The selection
did not follow either: -addObject: selected the first row whatever it
added, and -setContent: kept indexes past the end of shorter content (an
observer of selection.<key> then raised NSRangeException).  The arranged
objects are now updated inside the content change, and the selection
follows the objects, as on macOS 15: added objects are appended (arranged
again when rearranging automatically) and become the selection with
selectsInsertedObjects; removed ones are taken out; selected objects stay
selected with preservesSelection; avoidsEmptySelection picks the object at
the old index, or the last; -setSortDescriptors: and -setFilterPredicate:
rearrange.  `NSArrayController/arrangeOnChange.m` fails 11 of its 14
checks without the fix and passes with it on libs-gui 5c43a947f.

Added on 2026-10-17 for UDQuakeTools' GUI editor: `opengl-view-hidden`.
On X an NSOpenGLView draws into an X window of its own over the view's,
and hiding the view (or a view it is in) left that window up, over what
was shown in its place.  A hidden view now clears its context's drawable;
drawing again then raised, since -_lockFocusInContext:inRect: made the
context current before giving it the view, which it now does first.
`NSOpenGLView/hidden.m` fails 3 of its 6 checks without the fix and
passes with it on libs-gui fdc5cfe, under Xvfb with Mesa's GLX.

Added on 2026-10-19 for Logbook's Remove buttons:
`arraycontroller-remove-action`.  NSArrayController had no remove: of its
own, so the action went to NSObjectController's, which sent -removeObject:
the content array itself: nothing was removed.  It now removes the
selected objects through -removeObjectsAtArrangedObjectIndexes:, as macOS
15 does.  `NSArrayController/removeAction.m` fails 3 of its 4 checks
without the fix and passes with it on libs-gui 5c43a947f.

Added on 2026-10-19 for UDCode's navigator bar: `xib-segment-image`.  A
segment named its image in an attribute (`<segment image="name"/>`), and
the xib unarchiver's key map turned the key NSSegmentItem decodes it under
into that attribute's name, so the segment was given the name, a string,
as its image, and laying it out sent the string -size, which raised: a
window whose segmented control had images failed to load.  The image is
now looked up by name, by the decoder already registered for the key.
`GSXib5KeyedUnarchiver/segmentedCell.m` fails 2 of its 7 checks without
the fix and passes with it on libs-gui 87c1129; the rest of the gui suite
passes with it.

Added on 2026-10-19 for Logbook's xib: `arraycontroller-decoded-defaults`.
Interface Builder writes selectsInsertedObjects, avoidsEmptySelection,
preservesSelection and clearsFilterPredicateOnInsertion into a xib only
when NO, and NSArrayController's -initWithCoder: left each unset flag at
zero, so a xib's array controller selected nothing it added (its Remove
button stayed disabled after Add).  They now start at YES, what macOS 15
gives a xib controller with no attributes.
`NSArrayController/decodedDefaults.m` fails 4 of its 6 checks without the
fix and passes with it on libs-gui 5c43a947f.

On 2026-10-18 libs-gui merged #978 (0a4322d) as it was sent, and
`graphicscontext-backend-recursion` left: on libs-gui master it
reverse-applies whole, so `apply-patches.sh` was already skipping it.  The
other eighteen libs-gui patches apply to master 87c1129.  RDLKit, which the table
listed as carrying it, applies this repository at a pinned commit and holds
no copy.

Added on 2026-10-19: `xib-runtime-attributes`.  No user-defined runtime
attribute in a xib was applied to anything, view or controller: the xib
unarchiver stored them under "<id>.%IBAttributePlaceholdersKey" and the
loader looked under "<id>.IBAttributePlaceholdersKey".  db57ab788 (2020)
turned the format @"%@.IBAttributePlaceholdersKey" into a postfix and
kept its percent sign.  `GSXib5KeyedUnarchiver/runtimeAttributes.m` fails
3 of its 4 checks without the fix and passes with it on libs-gui
5c43a947f.

Added on 2026-10-19 for FreeCoreData's in-memory predicate evaluation:
`predicate-aggregate-of-nil`.  A comparison with ANY, ALL or NONE raised
when its left hand side was nil, so `ANY owner.vehicles.odometer > 5`
raised for an object without an owner.  macOS takes nil as an empty
collection there (ANY false, ALL and NONE true; checked on macOS 15 over a
nil to-one, a nil to-many and a missing key, with `>` and `== nil`), and
so does this now; a value that is neither nil nor a collection still
raises on both.  `NSPredicate/aggregateOfNil.m` fails 9 of its 11 checks
without the fix and passes with it; the NSPredicate suite passes 362 of
362 on libs-base 7c81d0c, and every libs-base patch here co-applies.

Added on 2026-10-19 for Logbook's controllers: `controller-entity-mode`.
NSObjectController had entity mode's accessors but not its behaviour:
-fetchWithRequest:merge:error: was a stub, so -fetch: did nothing;
-newObject ignored the entity; removing deleted nothing; managedObjectContext
was not an exposed binding (a xib's binding of it was refused); a xib's
entityName was not read; and -initWithCoder: asked
automaticallyPreparesContent before decoding it.  It now does what macOS 15
does: managedObjectContext and fetchPredicate are bindings, fetching uses
-defaultFetchRequest (entity, fetch predicate, an array controller's sort
descriptors) and fills the content (merging when asked), -fetch: and
-setFetchPredicate: fetch on the next pass of the run loop, -newObject
inserts into the context, what is removed is deleted unless the content is
bound, and a decoded controller with automaticallyPreparesContent fetches
or prepares.  Once it has fetched, it follows its context's
NSObjectsChangedInManagingContextNotification as macOS 15 does: inserted
objects of the entity that match the fetch predicate are added, deleted
and invalidated ones dropped, updated ones added or dropped as they now
match, refreshed ones left in it but said of the arranged objects (since
2026-10-21, below), and invalidatedAll empties the content
(see its NOTES.md).  Core Data is reached by class name at run time, not
linked; the notification and its keys are named by their values, which
FreeCoreData shares with Apple's from FreeCoreData#90.
`NSArrayController/entityMode.m` stands in for Core Data with classes of
the same names; it does not build without the fix (the binding name is
new), and with the name spelt out it fails its first four checks and then
crashes; without following the context, it fails 12 of its 41.  It
passes with the fix on libs-gui 5c43a947f, and a program loading the same
kind of xib over FreeCoreData's in-memory store fails 8 of 10 checks on
the stack the ormkit-gnustep image has and passes all with every libs-gui
patch here.  A program following a context of FreeCoreData's fails 4 of 7
checks over FreeCoreData master and passes all over FreeCoreData#90.  It
applies after `arraycontroller-arrange-eagerly` (see its NOTES.md).

Changed on 2026-10-21, for Logbook's pick lists: a refreshed object of
the content is said of the arranged objects (will/didChange
arrangedObjects), as macOS 15 does (checked there over Core Data: one
notification for each refreshed object, the content as it was, nothing
filtered or sorted anew), so that what shows them reads them again.  A
kind of expense added in Logbook's lists window and named before it was
saved kept its first name in every pop-up of it: the window reads its
objects again after saving (refreshes them), which on macOS rebuilds the
pop-ups and here did not.  `entityMode.m` has a check of it, which fails
without the change and passes with it; with every libs-gui patch here
applied (they all still apply after the change), NSArrayController's
tests all pass, and Logbook's desktop self-test, 302 checks, passes over
this gui.

Added the same day, also for FreeCoreData:
`predicate-ordering-without-compare`.  <, <=, >, >= and BETWEEN with a
left hand side that has no -compare: of its own (an array, a set, a
dictionary, an NSValue, a plain object) fell back on NSObject's deprecated
-compare:, which orders by address, so `owner.vehicles.odometer > 5`
answered by chance; macOS raises NSInvalidArgumentException for all of
them, and so does this now.  A 715-case probe (left: array, set,
dictionary, object, NSValue, NSNull, date, number, string, nil and a class
with its own -compare:; right: number, string, nil, array; seventeen
operators with their [c] forms) agrees with macOS apart from six cases
left alone: a date ordered against a tagged string or double (NSDate's
isSmallDate takes any tagged pointer for a date, a bug of NSDate's own)
and BETWEEN with numeric bounds on a date or on a class with its own
-compare: (macOS sends the bound -compare: there).

Added on 2026-10-19 for ORMKit's apps over FreeCoreData:
`predicate-string-escapes`.  A quoted string in a predicate format was
taken verbatim up to the next quote; macOS reads its backslash escapes
(`\\`, `\"`, `\'`, `\n`, `\t`, `\r`, `\uXXXX`, `\xHH`, `\ooo`, and any
other escaped character as itself; checked on macOS 15).  -predicateFormat
escapes a backslash and a double quote, so a predicate read back from its
description doubled every backslash: FreeCoreData keeps an attribute's
validation predicates as their formats, and Logbook's volume unit pattern
`^(?:L|gal \(US\)|gal \(imp\))$` refused 'gal (US)'.  The format walker
that collects the arguments now skips an escaped quote too.
`NSPredicate/stringEscapes.m` fails 11 of its 13 checks without the fix
and passes with it; the NSPredicate suite passes 446 of 446 on libs-base
b5cb2a6 with every libs-base patch here, and the patch applies to that
master alone too.
`NSPredicate/orderingWithoutCompare.m` fails 30 of its 36 checks without
the fix and passes with it on libs-base 7c81d0c; with every libs-base
patch here applied, the NSPredicate suite passes 433 of 433.

Added on 2026-10-19 for Logbook, ORMKit's sample app, whose decimal
fields lost their formatters' settings on GNUstep, so "12345" typed
into one became a double instead of the NSDecimalNumber its Core Data
attribute needs.  Every setting macOS keeps for a formatter now takes
effect and survives a keyed archive, read or written on either system.
Each fix below was checked against macOS 15: the tests' expected values
are what macOS gives (each test also passes there), and archives of the
same 13 formatters, written on each system and read on the other,
describe the same formatters (the 10.0 number formatter aside, see
below).

- `formatter-keyed-attributes` (libs-base).  macOS archives a formatter's
  settings in an `NS.attributes` dictionary keyed by property name, beside
  10.0 keys such as `NS.decimal` and `NS.format`.  NSNumberFormatter read
  only the 10.0 keys, NSDateFormatter read a keyed archive as an unkeyed
  one, and neither wrote one macOS could read.  Both now read
  `NS.attributes` by key-value coding (behaviour, locale and style first);
  with the 10.4 behaviour the 10.0 keys, which repeat settings as they
  stood in the writer's locale, are read for a 10.0 formatter only.  They
  write what differs from a new formatter with the same locale and style,
  plus what macOS always writes, BOOLs as booleans.
  `NSNumberFormatter/keyedAttributes.m` fails 20 of 27 checks without the
  fix and `NSDateFormatter/keyedAttributes.m` 15 of 21.
- `keyed-archive-value-classes` (libs-base).  NSLocale, NSTimeZone,
  NSCalendar, NSDecimalNumber and NSDecimalNumberHandler (now NSCoding)
  archive themselves with macOS's keys in a keyed archive, so each system
  reads the other's; NSKeyedUnarchiver falls back on the classes in
  `$classes`, as macOS does (macOS writes decimals as
  NSDecimalNumberPlaceholder).  `NSKeyedArchiver/macosValueClasses.m`,
  with archives macOS wrote (`macos-*.plist`), fails 20 of 25 checks
  without the fix; `NSNumberFormatter/macosArchive.m` and
  `NSDateFormatter/macosArchive.m` read formatters macOS archived.
- `nsdateformatter-settings` (libs-base, on `formatter-keyed-attributes`).
  AM/PM symbols could not be set; symbols, leniency and the two-digit
  start were lost whenever ICU's formatter was remade; setting weekday
  symbols raised; defaultDate, gregorianStartDate and
  generatesCalendarDates did nothing; formattingContext was missing;
  -getObjectValue:forString:range:error: always failed.  Defaults are
  macOS's (not lenient, two-digit years from 1950, missing fields from
  2000).  NSHTTPCookie relied on ICU's old leniency for Expires dates and
  now asks for it.  `NSDateFormatter/settings.m` fails 35 of 42 checks
  without the fix.  Not lenient is macOS's, not ICU's strict parsing (see
  the amendment of 2026-10-20 above).
- `nsnumberformatter-settings` (libs-base, on `formatter-keyed-attributes`).
  nilSymbol did nothing and zeroSymbol replaced the zero digit; the
  infinity symbols were one; the five textAttributesFor... did nothing;
  roundingIncrement took only doubles and multiplier only whole numbers;
  currencyCode used the wrong ICU key; positive and negative formats were
  ignored with the 10.4 behaviour; parsing checked neither minimum,
  maximum nor allowsFloats and took a string that only began with a
  number; four styles were missing.  Attribute getters cached ICU's
  values, so a BOOL set to NO came back YES after a change of locale or
  style.  `NSNumberFormatter/settings.m` fails 53 of 70 checks without
  the fix.
- `numberformatter-parse-decimal` (libs-base).  With
  generatesDecimalNumbers set, -getObjectValue:forString:range:error:
  refused every string: its unum_parseDecimal() call was under `#if 0`.
  `NSNumberFormatter/parseDecimal.m` fails 9 of its 10 checks without the
  fix.
- `xib-formatter-attributes` (libs-gui).  A xib's numberFormatter and
  dateFormatter elements carry their settings as attributes and child
  elements; the xib unarchiver presents them as `NS.attributes`, turning
  Interface Builder's names into values, and gives a date formatter the
  10.4 behaviour whatever the xib says, as macOS does.  It needs
  `formatter-keyed-attributes`.  With the libs-base fixes,
  `GSXib5KeyedUnarchiver/formatters.m` fails 19 of its 28 checks without
  this one.

`formatter-keyed-attributes`, `keyed-archive-value-classes` and
`numberformatter-parse-decimal` apply alone to libs-base 7b3a12c; the two
settings patches apply on top of `formatter-keyed-attributes`, which
`apply-patches.sh` applies first.  With every patch here, the base suite
passes 14320 checks (one file, `GSMime/encoded-word-stack.m`, aborts on
unpatched master as well; NSURLSession's local-server tests sometimes
time out, and pass 147 of 147 when run again) and the gui suite 5006.
Not done: a 10.0 number formatter still formats with GNUstep's own 10.0
code, which differs from macOS (grouping, padding); NSCalendar's -locale
and a date formatter's -locale carry a calendar keyword once a calendar is
set (archives leave it out, as macOS's do); a pattern with a suffix
(`0.00 'u'`) parses only with the suffix, where macOS also takes it
without; and `[NSDate dateWithTimeIntervalSinceReferenceDate: 0]` is 2
seconds on GNUstep, a separate bug in NSDate's small dates.
Added on 2026-10-19 for Logbook, ORMKit's sample app, whose pop-ups choose
a related object (a unit, a kind of cost, a driver):
`popup-content-bindings`.  NSPopUpButton did not expose content,
NSContentObjectsBinding was not declared, contentValues replaced the items
by their titles (dropping any title that repeats) and selectedObject
selected by tag, sending the object -intValue.  The three content bindings
now build the items as on macOS: content gives the represented objects,
contentValues the titles, contentObjects what selectedObject is matched
against and set to; NSInsertsNullPlaceholder adds a first item for nil;
selectedObject follows the model both ways, a nil or an object not in the
content shown as an extra last item as AppKit shows it; and selectedIndex
counts the content, not the placeholder.  `NSPopUpButton/contentBindings.m`
passes 28 of 28 with the fix and on AppKit (macOS 15); without it (the
binding's name kept, so that it builds) 6 checks fail before the pop-up
raises on -intValue and ends the set.  On libs-gui 5c43a94.
Added on 2026-10-19 for Logbook, whose connect panel is an alert with a
server field on macOS: `alert-accessory-view`.  NSAlert had no
-accessoryView, -setAccessoryView: or -layout.  The accessory view is now
shown between the informative text and the buttons at its own size, the
panel grown to fit it, and -layout lays the panel out at once, so that its
window can be adjusted (a field made first responder) before it is run;
an alert laid out is run in that window.  `NSAlert/accessoryView.m` passes
8 of 8 with the fix and on AppKit (macOS 15), and without it stops at the
first check, NSAlert not recognising -layout.  On libs-gui 5c43a94.
Added on 2026-10-19 for Logbook's self-test, which types into a field
editor the way macOS input does: `textview-insert-replacement-range`.
NSTextView answered only NSTextInput, so the NSTextInputClient methods
raised: -insertText:replacementRange:, -setMarkedText:selectedRange:
replacementRange:, -attributedSubstringForProposedRange:actualRange: and
-firstRectForCharacterRange:actualRange:.  They are there now, as on
macOS (an NSNotFound range is the marked text, or else the selection),
and NSTextView declares the protocol; -insertText: and
-setMarkedText:selectedRange: go through them, and the latter no longer
takes its selected range for the range to replace.
`NSTextView/insertTextReplacementRange.m` passes 18 of 18 with the fix and
on AppKit (macOS 15); without it the conformance check fails and the set
stops at the first -insertText:replacementRange:.  On libs-gui 5c43a94.
Amended on 2026-10-26: a text view decoded from a nib had no marked range
set (-initWithCoder: left it {0, 0}, -initWithFrame: sets NSNotFound), so
it said it had marked text, and with -insertText: now replacing marked
text everything typed went to its start: SimpleNotes' typing on Linux.
-initWithCoder: sets it too; two checks on a decoded text view, now 20 of
20, fail without that line.  On libs-gui d340fc5e2.
Added on 2026-10-19 for Logbook, which quit when its connect window
closed and its logbook window opened in the same event:
`last-window-closed`.  -applicationShouldTerminateAfterLastWindowClosed:
was asked 0.1 s after a window closed if, as it closed, no other window
on the server's stacking list could become main, without looking again.
macOS (checked on macOS 15) asks at the end of that event, and not if a
window has come in by then; once for several windows closed together;
and a panel on screen does not count.  The check is now made again when
it is time to ask, from the windows' own visibility, at the end of the
event.  macOS also asks when the last window is only ordered out; that is
left alone.  `NSApplication/lastWindowClosed.m` runs the application
through six cases and passes 6 of 6 with the fix and on AppKit; without it
the two where a window comes in the same event fail.  On libs-gui 5c43a94.
Added on 2026-10-20 for RDLKit's cross-platform report check, which
renders its corpus of 97 reports to PDF on macOS 15 and on the stack and
compares them, and drives RDLDesigner on both; every fix was checked
against macOS 15 first.  On libs-base d537eac97, libs-gui cacd5cb08 and
libs-back d378734; each test fails without its fix and passes with it.
`font-family-names` (libs-gui): +fontWithName:size: took only PostScript
names, so "Arial" or "Times New Roman" was nil and every report fell back
to the system font; macOS also takes a family name (its regular face) and
a full name, in any case, and names the font by its PostScript name.
`NSFont/familyname.m`, 8 checks.  `cairo-unhinted-metrics` (libs-back):
GSFontHinting defaulted to 33, hinted metrics, so every advance was
rounded ("line wraps here" in Arial 10 measured 70.0, 67.8 on macOS); the
default is now 17, unhinted, as the backend already used with a scale
factor.  `Tests/cairo/unhintedmetrics.m`, 3 checks.
`cairo-screen-font-size` (libs-back): a screen font's size was rounded up
to a whole point, so string drawing measured 14.5-point text at 15;
macOS's -screenFont keeps the size.  `Tests/cairo/screenfontsize.m`, 3.
`landscape-pdf-pages` (libs-gui and libs-back, a pair that goes
together): landscape was turned a quarter round onto a portrait sheet in
PDF too; macOS makes a landscape page ([0 0 842 595]).  gui now draws
landscape upright into a PDF (one page per sheet) and says so with
GSPrintLandscapeSheets, which the cairo context reads to keep the page
landscape; PostScript is unchanged.  `NSPrintOperation/landscapePDF.m`, 2,
and `Tests/cairo/pdflandscape.m`, 3 (it links zlib to read cairo's object
streams).  `layoutmanager-font-leading` (libs-gui): lines were the
backend's unrounded line height (Arial 10: 11.499, macOS 11.327 or 11.0);
NSFont's -leading was 0, -usesFontLeading was missing and
lineHeightMultiple was ignored.  The typesetter now rounds the ascender
and descender, adds the leading when the layout manager uses it, scales
by the multiple with the extra above the baseline, lets line spacing
replace the leading except under the last line, and string drawing adds
the leading only with NSStringDrawingUsesFontLeading; the layout of every
case probed matches macOS to the thousandth of a point, paragraph spacing
apart (left as it was: paragraphSpacingBefore is still ignored).
`NSLayoutManager/fontLeading.m`, 66 checks over the fonts installed.
`cairo-dash-lengths` (libs-back): every dash length was multiplied by 1.4;
macOS writes "[ 6 3 ] 1 d".  `Tests/cairo/dashpattern.m`, 6.
`modal-stop-from-timer` (libs-gui): -stopModal, -stopModalWithCode: and
-abortModal from a timer left the loop waiting for an event; it now ends
at once, as on macOS (0.5 s).  `NSApplication/stopModalFromTimer.m`, 6.
`pdf-ligature-text` (libs-back): ligature glyphs reached the PDF as
U+FB01..., so text copied or searched read "ﬁnish"; they now carry the
letters as ActualText, as macOS's do.  `Tests/cairo/pdfligatures.m`, 4.
`scrollview-nib-document-origin` (libs-gui): a scroll view from a nib
opened scrolled away from its document's origin when the clip view was
resized after decoding (RDLDesigner's canvas, 98 points down); macOS
scrolls to the origin when the nib sets the document view.
`NSScrollView/nibDocumentOrigin.m` with `DocumentOrigin.xib`, 7.
`splitview-set-position-bounds` (libs-gui): -setPosition:ofDividerAtIndex:
did not stop at the ends and gave a subview a negative height; it now
stops as macOS does.  `NSSplitView/setPositionBounds.m`, 6.
`control-state-value-signed` (libs-gui) and `urlsession-task-state-signed`
(libs-base): NSControlStateValue and NSURLSessionTaskState were unsigned,
so -state sent to an id warned "Calling [NSFormCell -state] with incorrect
signature"; both are NSInteger in Apple's headers.
`NSSwitch/stateType.m`, 6, and `NSURLSession/taskState.m`, 3.
`cairo-window-surface-termination` (libs-back): the window's Render
picture was freed by the X server with the window and again by cairo, one
RenderBadPicture per closed window; the surface now lets go first.
`Tests/x11/windowclose.m`.  Not GNUstep's: the New Report panel's radio
buttons (their states are right; the default theme draws them that way),
and the scroller on the left, which is GNUstep's interface style default.
Added on 2026-10-20 for RDLKit's designer UI tests, checked against
macOS 15, on libs-gui cacd5cb08.  `pasteboard-clear-contents`:
-clearContents raised; it now clears the pasteboard, tells its owner and
returns the new change count, and -writeObjects: (which returned NO),
-readObjectsForClasses:options:, -canReadObjectForClasses:options: and
-pasteboardItems work, with NSString adopting NSPasteboardWriting and
NSPasteboardReading; the pasteboard holds one item, so where macOS keeps
one per object written the first object's types are kept, and URLs,
images and colours do not adopt the protocols yet.
`NSPasteboard/clearContents.m`, 14 checks; without the fix the first
fails and the rest cannot run.  `window-sheet-api`: NSWindow had no
-endSheet:, -endSheet:returnCode:, -sheets, -isSheet or
-beginCriticalSheet:completionHandler:, and -sheetParent was nil; they
end the window's sheet through NSApp (the handler is called while the
sheet is up, then it is ordered out, as on macOS) and report it.  Sheets
stay modal: -beginSheet:completionHandler: returns when the sheet ends,
where macOS returns at once.  `NSWindow/sheetAPI.m`, 6 of 7 fail without
it.  `colorspace-srgb`: +sRGBColorSpace and the other named spaces
(extended sRGB, Display P3, Adobe RGB (1998), gamma 2.2 gray and its
extended form) were missing; they are there with macOS's names, a
+colorWithSRGBRed:... colour is in sRGB, and -colorUsingColorSpace:
converts to sRGB and gamma 2.2 gray, keeping components since GNUstep
does no colour management.  `NSColorSpace/standardSpaces.m`, 25 checks,
all but one failing without it.
Added on 2026-10-20, the leftovers of `nsdate-tagged-roundtrip`, checked
against macOS 15 on libs-base d537eac97; each applies alone to master and
after that one.  `nsdate-small-date-tag`: a small date was recognised by
(ptr & 6), true for every small object with tag 2 to 7, so a tiny string
or a small double or float was taken for a date and its bits decoded as an
interval: `[d isEqual: @"ab"]` was YES for the date @"ab" decodes to, and
-compare:, -timeIntervalSinceDate:, -laterDate: and -earlierDate: with a
string or a number answered instead of raising.  The whole tag is
compared now; those five methods were its only users.
`NSDate/notADate.m`, 20 of 30 checks fail without it.  The same test of
one bit is in GSString's literalIsEqual (old string ABI only, not built
here), left alone.  `nsdate-equal-hash`: -isEqual: compares intervals
whatever the class, but a small date hashed its pointer and every other
date (NSCalendarDate, a heap date, a subclass) `(NSUInteger)interval`,
so equal dates of different classes hashed apart and a set of NSDates
did not find an equal NSCalendarDate; the cast also gave every date in a
second one hash, and every negative one 0 on arm64.  Every date now hashes
its interval with NSNumber's double hash (moved to GSPrivateHashDouble()),
0 and -0 alike, as macOS hashes every date class by its interval.
`NSDate/hash.m`, 3 of 4 fail without it.  `calendardate-distant-years`:
NSCalendarDate (and so NSDate's -description) never returned for a date
more than a day before the year 1, searched year by year (hours for
1e20 seconds) and printed garbage years past an int.  The year now comes
from 400/100/4/1-year cycles in constant time, years before 1 are
proleptic Gregorian with a year 0, as macOS's NSCalendarDate has them
(-initWithYear: and -dateByAddingYears: too), and dates are held to the
years an int holds (midnight of the first or last day; macOS prints the
year 2147483647 with a garbage time).  `NSCalendarDate/distantYears.m`,
35 checks, does not return without it.  macOS's NSDate -description is
an empty string beyond about 5.8 million years (ICU); GNUstep's is the
NSCalendarDate's.
With every patch here, the base suite passes 14737 checks with none
failing (`GSMime/encoded-word-stack.m` aborts, as on unpatched master).
Added on 2026-10-20, found by LogBook (`-startOfDayForDate:` missing),
checked against macOS 15 on libs-base d537eac97.  `nscalendar-modern-api`:
NSCalendar had almost none of the 10.9 API (-startOfDayForDate:, the
-isDateIn... and weekend methods, -dateByAddingUnit:..., -dateBySetting...,
-nextDateAfterDate:..., -enumerateDatesStartingAfterDate:..., granularity
comparison, -componentsInTimeZone:fromDate:, -dateWithEra:...,
-components:fromDateComponents:..., -minimumRangeOfUnit:); all are added,
the searches following Apple's rules for missing days, daylight saving
gaps and repeated times.  On the way: NSCalendarIdentifierISO8601 was ""
and three identifiers were not ICU's names (so those calendars were
Gregorian); unknown identifiers now give nil; -copy returned the receiver;
a day without or with two midnights had the wrong start or length;
nanoseconds were milliseconds (and -getHour:... gave microseconds); the
era difference was nil; -ordinalityOfUnit:... was 0; -isValidDate... was
YES for 30 February; -valueForComponent: gave 0 for unset units;
NSDateComponents had no -isEqual:.  Backward searches return the latest
match before the date, where macOS is inconsistent (see the commit
message).  `NSCalendar/features-10-9.m` and `NSCalendar/nextDate.m`, 503
checks from macOS tables; without the fix both sets fail (161 failures).
With every patch here, the base suite passes 15239 checks with none
failing (`GSMime/encoded-word-stack.m` aborts as on master; `NSStream/socket.m`,
which talks to google.com, aborted once and passed on three reruns).
Added on 2026-10-20 for Logbook's records, a Core Data to-many bound
through the vehicles' selection with contentSet and filtered:
`controller-to-many-set`.  An array controller kept set content as the
set and arranged it as an array, so a filter predicate raised
("GSSet does not recognize filteredArrayUsingPredicate:").  On macOS 15
a controller's content is always an array: a set given to -setContent:
or through contentSet becomes a mutable array of its objects (arranged,
unsorted, in -allObjects order), and adding or removing through a bound
set still changes the set; a mutable set given unbound is left alone.
The controller now does the same.  `NSArrayController/setContent.m`
passes its 23 checks on macOS 15; without the fix 3 of its first 6 fail
and the set stops at the exception.  It applies after
`controller-to-many-content`.
With it Logbook's self-test went on to its Done sheet, whose pop-up binds
contentValues to doneEvents.lbTitle, a list the controller fills only in
-awakeFromNib: `popup-content-bindings` decided whether a key path passes
through a to-many from the values on it when the binding was made, and
with doneEvents still nil it observed the whole key path, which libs-base
refused once doneEvents became an array.  It now observes up to a nil
too and decides again when that part changes, as macOS 15 does (with
content bound as well).  The second set of
`NSPopUpButton/contentValuesKeyPath.m` passes its 7 checks on macOS 15;
with the choice made only when binding, 2 fail and the set stops at the
exception.  With both, Logbook's `make clean; make -k check` passes
(self-test done: 0 failed, 269 checks) on the 2026.10.20.4 image with
every patch here, and the gui suite passes 5368 checks with none failing,
on libs-gui cacd5cb08.
Added on 2026-10-20 for Logbook's pick lists, checked against macOS 15
first: `controller-value-bindings`, `controller-fetch-sort-keys` and
`objectcontroller-deferred-add`.  An array controller exposed no
sortDescriptors binding ("No binding exposed on <NSArrayController> for
sortDescriptors", seven times in Logbook's self-test), nor
filterPredicate, nor an object controller editable.  On macOS 15 they
are exposed, the controller follows the bound value, and gives a change
of its own to the sort descriptors, the filter predicate or the
selection back to the bound object; `NSArrayController/valueBindings.m`
passes its 30 checks there, and 22 fail without the fix.
contentArrayForMultipleSelection is still not exposed.  With the
binding working, Logbook's pick lists, sorted by a computed title, came
up empty: the controller sent every sort descriptor in its fetch
request, and the OData store refused the one that is no attribute.
macOS 15 sends only the leading sort descriptors on stored attributes
compared with -compare:, and so does `controller-fetch-sort-keys` (3 new
checks in `NSArrayController/entityMode.m`, which fail without it; it
applies after `controller-entity-mode`, whose -defaultFetchRequest it
changes).  And on macOS 15 -add: and -insert: are done at the next turn
of the run loop, in the default, modal panel and event tracking modes:
until then nothing is made, added or selected and observers hear
nothing; whether the controller can add is asked then; -insert: inserts
at the selection, or at the end.  They acted at once here and -insert:
appended.  `NSObjectController/deferredAdd.m` passes its 29 checks on
macOS 15; 13 fail without the fix.  With all three, Logbook's
`make clean; make -k check` passes (self-test done: 0 failed, 269
checks; procedures: 0 failed) on the 2026.10.20.5 image (FreeCoreData
0.8.2) with every libs-gui patch here, with no "No binding exposed" in
its log; its self-test already spins the run loop after each click.  The
gui suite, with every libs-base, libs-gui and libs-back patch here on
libs-gui cacd5cb08, passes 5427 checks; the 3 failing are
`NSApplication/stopModalFromTimer.m`'s, which fail the same in that
container without these patches (its libs-base is older than the
released stack's; on the released stack they pass, below).
Then three more, found on the way and checked against macOS 15 first:
`objectcontroller-when-can-add`: -canInsert was always YES and -canAdd
was -isEditable; on macOS -canInsert is -canAdd, neither holds when the
controller is not editable or has an entity and no context, an array
controller bound through a selection with nothing selected cannot add,
and an object controller can add only while it has no content
(`NSObjectController/canAdd.m`, 11 checks, 7 fail without the fix).
`selection-equal-objects`: objects were looked up with -indexOfObject:,
so of equal objects only the first was selected, an inserted object
was selected as the first equal one, and removing by arranged index
removed every equal object; on macOS selecting by objects takes every
equal one, inserting selects what was inserted, and removing by index
removes those objects only (`NSArrayController/equalObjects.m`, 20
checks, 15 fail without the fix).  `selection-new-content`: a
controller made with content selected nothing, and every rearrangement
avoided an empty selection; on macOS new content selects its first
object when nothing of the selection is left, and rearranging never
selects (`NSArrayController/initialSelection.m`, 15 checks, 4 fail
without the fix).  All sort after the other controller patches and
apply with every patch here to libs-gui master cacd5cb08 with no fuzz.
On the released stack (ormkit-gnustep, gnustep-patches 2026.10.20.5)
with libs-gui rebuilt with every patch here, the gui suite passes 5507
checks with none failing, `stopModalFromTimer.m`'s 6 among them, and
Logbook's `make clean; make -k check` passes (self-test done: 0 failed,
269 checks; procedures: 0 failed), with no "No binding exposed".

Added on 2026-10-21 for Logbook's sync on GNUstep: `uuid-secure-coding`.
NSUUID adopted NSCoding only, so a keyed archive holding a UUID could not
be read with any secure decode, even with NSUUID allowed: the decode
returned nil ("class 'NSUUID' does not support secure coding").
ODataSync keeps each waiting change's key as such an archive and reads
it with +unarchivedObjectOfClasses:fromData:error:, so every object
keyed by a UUID attribute was dropped from its outbox unsent (Logbook's
vehicles, fill-ups, services and reminders never left the device); on
macOS, where NSUUID adopts NSSecureCoding, they go.  The patch adopts it
here and answers YES to +supportsSecureCoding.  `NSUUID/secure.m` in
libs-base's suite, 5 checks, fails all 5 on master 555420c and passes
with the fix (NSUUID 26 of 26); with every libs-base patch here applied,
NSPredicate passes 446 of 446 and NSKeyedArchiver 110 of 110.  With the
same two methods given to NSUUID in a stand-in (a category, never
committed), ODataKit's GNUstep suite passes 428 of 428, its new test of
UUID-keyed objects among them, and so does Logbook's
`make clean; make -k check` once its sync check reads the server's row
uncached (below).

Found beside it, not patched yet: libs-base's +[NSData
dataWithContentsOfURL:] reads an http URL with
-resourceDataUsingCache: YES, so a second read of the same URL answers
the first one's bytes; on macOS it reads the URL again.  Logbook's sync
check reads `Records(<id>)` after each round and saw the first round's
row; -dataWithContentsOfURL:options:NSDataReadingUncached error: reads it
afresh here.

Added on 2026-10-21 for Logbook's desktop app: `kvo-nested-value-kept`.
Observing a key path like `selectedObjects.@count` attaches the rest of
it (`@count`) to the value the first key has then, and the key observer
kept that value unretained.  NSArrayController's -selectedObjects makes a
new array on each call, so once the autorelease pool it came from
drained, the array was freed, and the next change detached the old
observation from freed memory.  Logbook's main window crashed on its
first vehicle: its Open button's enabled binding is to the attachments
controller's `selectedObjects.@count`, and that controller's contentSet
is bound to the records controller's `selection.attachments`, itself
bound to the vehicles' `selection.records`.  On macOS it works.  The
patch keeps the value retained while the rest of the key path is
observed on it.  `NSKVOSupport/nestedComputedValue.m` in libs-base's
suite, 5 checks, fails its first on master 1534933 and then crashes, and
passes with the fix (NSKVOSupport 530 of 530).  With every libs-base
patch here applied, the whole suite passes 15256 tests; what fails,
NSAutoreleasePool/dispatch.m and GSMime/encoded-word-stack.m, fails the
same without it.  A stand-alone program
with that chain of three controllers and the button reads freed memory
under valgrind and crashes without it and runs clean with it; Logbook,
with both bindings back, crashes three checks into its self-test on
2026.10.20.7 and passes all 113 with this base.

Added on 2026-10-22 for Logbook's desktop app: `locale-currency-name`.
-[NSLocale displayNameForKey:value:] answered nil for NSLocaleCurrencyCode
and NSLocaleCurrencySymbol, keys it did not handle, where macOS names the
currency in the locale's language ("Japanese Yen", "dollar des
États-Unis") and says its symbol ("$"). Logbook's currency field lists
and finds currencies by those names, so on GNUstep "yen" found nothing.
The patch takes both from ICU's ucurr_getName and answers nil for a code
ICU does not know, as macOS does. `NSLocale/currencyName.m` in
libs-base's suite: on master 1534933 with every libs-base patch here
applied, four of its five checks fail; with the fix all pass, and the
whole suite passes 15250, the two files that fail
(NSAutoreleasePool/dispatch.m, GSMime/encoded-word-stack.m) failing the
same without it.

Added on 2026-10-26 for FreeCoreData's Windows installer, whose launcher
starts Model Builder and the samples: `nsbundle-windows-exe` and
`nstask-windows-gui-shown`. On Windows -[NSBundle executablePath] answered
<name> for another application's bundle, a file that does not exist: its
.dll fallback was guarded by `[name pathExtension] == nil`, which an empty
extension never is, and .exe was never tried. And NSTask started every
program with STARTF_USESHOWWINDOW and SW_HIDE (meant for consoles), which
Windows applies to a GUI program's first window too: an app a launcher
started ran with no window. The first now tries .dll and .exe when the name
has no extension; the second sets the show state only for a program whose
PE header says it is not a GUI program. `NSBundle/executableExe.m` and
`NSTask/guiShown.m` (with a helper built as a console and as a GUI program)
in libs-base's suite: on Windows, MSYS2 CLANG64, with every libs-base patch
here applied to master 1acaaef, each fails without its fix and passes with
it, and NSBundle (89) and NSTask (88) pass; on Linux both are skipped and
NSTask passes (92).
Added on 2026-10-27 for UDCode on Windows, whose debug adapter and language
servers talk over their standard input: `windows-stdin-pipe`. The win32
GSFileHandle took a standard input to be a console's whatever it was, and
peeked at a pipe's with PeekConsoleInput, which failed; the failure did
not end the read, so it was retried and logged without end. A standard
stream is a console's now only when GetFileType says so, and a failed peek
ends the read. Extended on 2026-10-27: such a stream is also put in binary
mode, as the C runtime opens the standard streams in text mode and each
`\n` written to a piped stdout came out as `\r\n` (a debug adapter's
Content-Length frames never arrived whole). `Tests/base/NSFileHandle/stdinPipe.m`
(a helper reading its piped stdin and writing it back to its piped stdout):
on Windows, MSYS2 CLANG64, the bytes check fails without the fix and both
pass with it; the NSFileHandle tests pass (41). Its commit says "Patch
done with help of AI." and carries no Claude trailer.

Added on 2026-10-27 for SimpleNotes on Windows, whose Sign In said the
browser could not be opened while it opened it: `workspace-open-url-quietly`.
For a URL nothing claims, -openURL: ran a modal alert first and the
system's opener (ShellExecute, xdg-open) only after it; the alert also
held up the sign-in waiting behind it. The opener is tried first now, the
alert only when it fails. `Tests/gui/NSWorkspace/openURLQuietly.m` in
libs-gui's suite: on Windows, MSYS2 CLANG64, every libs-gui patch here
applied, an alert without the fix and none with it. Its commit says
"Patch done with help of AI." and carries no Claude trailer.

Added on 2026-10-27 for SimpleNotes' Windows installer, whose windows had
a blank icon: `win32-window-icon`. The win32 server never set a window's
icon; it now sends WM_SETICON (big and small) made from the application's
icon, as the X11 server sets _NET_WM_ICON. `Tests/cairo/win32icon.m` in
libs-back's suite: on Windows, MSYS2 CLANG64, both checks fail without
the fix and pass with it. Its commit says "Patch done with help of AI."
and carries no Claude trailer, ready to send upstream.

Extended on 2026-10-27 for UDCalc and HomeRow on Windows: `arc4random-glibc`
now provides arc4random(), arc4random_uniform() and arc4random_buf() on
Windows too, whose C runtime has none, exported from the base DLL and
drawn from rand_s(). Its name is kept. `Tests/base/Functions/arc4random.m`
on Windows, MSYS2 CLANG64, every libs-base patch here applied: fails to
build without the change, passes with it, and the Functions suite passes.
Its commit says "Patch done with help of AI." and carries no Claude
trailer, ready to send upstream.

Added on 2026-10-27 for SimpleNotes on Windows, whose Export as PDF
aborted on any note with a picture: `pdf-lent-image`, in cairo itself, the
first patch here that is not GNUstep's. The stack has taken cairo from
MSYS2 until now; on Windows it is built here instead (cairo 1.18.6,
MSYS2's version, with this patch) and installed in the prefix's bin, ahead
of MSYS2's. cairo's PDF surface adds an image pattern with
CAIRO_EXTEND_PAD (gnustep-back's for every picture) through
_cairo_pdf_surface_add_padded_image_surface, which, needing no padding,
keeps the image its source lent it and then releases it; a Win32 surface
lends one it maps, and the release finishes it, so show_page asserts
"!surface->finished". The patch keeps a copy when the image is lent.
Upstream master has the same code. No test in cairo's suite (it needs a
Win32 surface): `pdf-pad-win32.c` beside the patch, 30 lines of cairo
alone, aborts with MSYS2's cairo and writes its page with the patched one;
gnustep-back printing a picture to PDF does the same. To be upstreamed by
hand, not from here.

Added on 2026-10-27 for SimpleNotes on Windows, whose italic text was
drawn upright: `system-font-segoe-ui`. On a Windows without DejaVu,
Bitstream Vera or FreeSans (an ordinary one; CI's runner), the fontconfig
enumerator's default system font was Tahoma, which has no italic face, so
converting the system font to italic gave Tahoma back. Segoe UI, Windows'
interface font, is tried before Tahoma now, and its bold before Tahoma's.
`Tests/cairo/systemfontitalic.m` in libs-back's suite: on Windows, MSYS2
CLANG64, with every libs-back patch here applied to master d378734 and
DejaVu hidden from fontconfig, it fails without the fix (Tahoma) and passes
with it (SegoeUI); skipped where Segoe UI is not installed. Its commit
says "Patch done with help of AI." and carries no Claude trailer, ready to
send upstream.

Added on 2026-10-22 for Logbook's desktop app: `xib-custom-view-identifier`.
A custom view of a xib is made by NSCustomView (GSNibLoading.m), which
gives the view its frame, autoresizing, hidden flag, key views and
subviews but not the identifier NSView's own -initWithCoder: decodes, so
every view of a xib but its custom views had the identifier Interface
Builder gave it. Logbook's UDQuantityField, an amount and its unit in one
custom view, names its number field and unit box by its identifier; on
GNUstep they had none, and its self-test found none of the 29 on its
forms. `GSXib5KeyedUnarchiver/customViewIdentifier.m` in libs-gui's suite
loads a window with a custom view of no class and one of NSControl: both
identifier checks fail without the fix and pass with it, and the whole gui
suite passes with it.

Added on 2026-10-22 for Logbook's desktop app: `thread-exit-after-atexit`.
A thread GNUstep knows of that ends while the process exits, after
NSValue's +atExit has destroyed its placeholders, is cleaned up by
exitedThread (NSThread.m), which boxes its pthread in an NSValue to look
it up by: none can be made any more, NSMapInsert raises on the nil key,
and the exception, where no handler can be, aborts the process. Logbook's
desktop self-test passed and then ended with SIGABRT every time once its
calendar had read twelve months ahead (more of ODataKit's HTTP worker
threads finishing as it quit). The patch lets such a thread end with the
process, as it is, when the box cannot be made. `NSThread/exit_after_atexit.m`
in libs-base's suite registers a pthread, runs NSValue's +atExit, and
lets the thread end: on master 1534933 with every libs-base patch here
applied it aborts; with the fix it passes, NSThread's tests all pass, and
the whole suite passes 15245, the two files that fail
(NSAutoreleasePool/dispatch.m, GSMime/encoded-word-stack.m) failing the
same without it. Logbook's app check, three runs over this base, exits 0
each time.

Added on 2026-10-21 for Logbook's desktop app: `tablecolumn-binds-table`.
On macOS a table column whose value is bound to an array controller binds
its table view's content, selectionIndexes and sortDescriptors to that
controller, unless the table's content is bound already (checked there:
an own selection binding is replaced, an own content binding kept, an
object controller binds nothing). Here nothing was bound, so a
controller's selection set in code never reached the table: Logbook's
lists window adds a kind of expense, chooses it and edits its name in
place, and -editColumn:row:withEvent:select: raised "Attempted to edit
unselected row". The patch binds the table so, when the column's value is
bound or the column is added to a table, and the table, told a selection
past the rows it has counted (a controller says its selection before the
table has reloaded), counts them again first. The header click does not
send the table's sort descriptors back to the controller here (not
patched). `NSTableView/boundSelection.m` in libs-gui's suite, 10 checks,
every one also run against AppKit on macOS: 7 fail on master fdc5cfe8
with every libs-gui patch here applied, all pass with the fix; the whole
gui suite passes 5481. Logbook's desktop self-test, its lists window
among it, passes with this gui and fails without it.

| Fix | Upstream | Test | PR | Carried by |
| --- | --- | --- | --- | --- |
| `autoreleased-return-value` | libobjc2 | test | [#426](https://github.com/gnustep/libobjc2/pull/426) closed unmerged | (none: ODataStore works around it) |
| `urlsession-lowercase-location` | libs-base | test | not sent yet | (none: UDCodeKit follows 3xx itself) |
| `predicate-secure-coding` | libs-base | test | not sent yet ([#766](https://github.com/gnustep/libs-base/issues/766)) | (none: FreeCoreData will use it from here) |
| `predicate-aggregate-of-nil` | libs-base | test | not sent yet | (none: FreeCoreData will use it from here) |
| `predicate-ordering-without-compare` | libs-base | test | not sent yet | (none: FreeCoreData will use it from here) |
| `predicate-string-escapes` | libs-base | test | not sent yet | (none: FreeCoreData and ORMKit's apps use it from here) |
| `arc4random-glibc` | libs-base | test | not sent yet | (none: every app built on the stack uses it from here, on glibc before 2.36 and on Windows; HomeRow's and UDCalc's shims are gone) |
| `windows-stdin-pipe` | libs-base | test | not sent yet | (none: UDCode's debug adapter on Windows uses it from here) |
| `collection-copy-is-shallow` | libs-base | test | not sent yet | (none: FreeCoreData uses it from here) |
| `nonretained-value-identity` | libs-base | test | not sent yet | (none: ORMKit uses it from here) |
| `xml-detached-namespaces` | libs-base | test | not sent yet | (none: ORMKit uses it from here) |
| `xml-remove-namespace-in-use` | libs-base | test | not sent yet | (none: ORMKit uses it from here) |
| `formatter-keyed-attributes` | libs-base | test | not sent yet | (none: ORMKit's apps use it from here) |
| `numberformatter-parse-decimal` | libs-base | test | not sent yet | (none: ORMKit's apps use it from here) |
| `keyed-archive-value-classes` | libs-base | test | not sent yet | (none: ORMKit's apps use it from here) |
| `nsdateformatter-settings` | libs-base | test | not sent yet (needs `formatter-keyed-attributes`) | (none: ORMKit's apps use it from here) |
| `nsnumberformatter-settings` | libs-base | test | not sent yet (needs `formatter-keyed-attributes`) | (none: ORMKit's apps use it from here) |
| `nsdate-tagged-roundtrip` | libs-base | test | not sent yet | (none: ORMKit uses it from here) |
| `nsdate-small-date-tag` | libs-base | test | not sent yet | (none: ORMKit uses it from here) |
| `nsdate-equal-hash` | libs-base | test | not sent yet | (none: ORMKit uses it from here) |
| `calendardate-distant-years` | libs-base | test | not sent yet | (none: ORMKit uses it from here) |
| `nscalendar-modern-api` | libs-base | test | not sent yet | (none: LogBook uses it from here) |
| `popover-placement` | libs-gui | test | not sent yet | (none: UDCodeKit places its own child windows meanwhile) |
| `arraycontroller-arrange-eagerly` | libs-gui | test | not sent yet | (none: Logbook's LBEntityController will drop its workaround) |
| `tableview-prototype-copy` | libs-gui | test | not sent yet | (none: UDCodeKit's issues navigator is cell-based meanwhile) |
| `arraycontroller-selection-kvo` | libs-gui | test | not sent yet | (none: Logbook's LBEntityController will drop its workaround) |
| `tooltip-mouse-moved` | libs-gui | test | not sent yet | (none: UDCodeKit resets the flag itself) |
| `arraycontroller-remove-action` | libs-gui | test | not sent yet | (none: Logbook's Remove buttons use it from here) |
| `view-overlapping-siblings` | libs-gui | test | not sent yet | (none: UDCodeKit's jump-to-line box needs it, ashalkhakov/UDCodeKit#43) |
| `arraycontroller-decoded-defaults` | libs-gui | test | not sent yet | (none: Logbook's xib uses it from here) |
| `opengl-view-hidden` | libs-gui | test | not sent yet | (none: UDQuakeTools' GUI editor uses it from here; its workaround is gone) |
| `xib-runtime-attributes` | libs-gui | test | not sent yet | (none: every xib with runtime attributes uses it from here) |
| `xib-segment-image` | libs-gui | test | not sent yet | (none: UDCode's navigator bar uses it from here) |
| `xib-formatter-attributes` | libs-gui | test | not sent yet | (none: ORMKit's apps use it from here) |
| `popup-content-bindings` | libs-gui | test | not sent yet | (none: Logbook will use it from here; its LBObjectPopUpButton goes) |
| `alert-accessory-view` | libs-gui | test | not sent yet | (none: Logbook will use it from here; its ConnectPanel.xib can go) |
| `textview-insert-replacement-range` | libs-gui | test | not sent yet | (none: Logbook will use it from here; its #ifdef in LBSelfTest.m goes) |
| `last-window-closed` | libs-gui | test | not sent yet | (none: Logbook will use it from here; its terminate on the window's close can go) |
| `tableview-column-autoresizing-style` | libs-gui | test | [#982](https://github.com/gnustep/libs-gui/pull/982) | gnustep-coredata |
| `collectionview-make-item` | libs-gui | test | [#1001](https://github.com/gnustep/libs-gui/pull/1001) | (none: TopoText uses it from here) |
| `collectionview-flow-layout` | libs-gui | test | [#1002](https://github.com/gnustep/libs-gui/pull/1002) | (none: TopoText uses it from here) |
| `textview-attachment-double-click` | libs-gui | test | [#1004](https://github.com/gnustep/libs-gui/pull/1004) | (none: TopoText uses it from here) |
| `splitview-set-position-did-resize` | libs-gui | test | not sent yet | (none: TopoText uses it from here) |
| `tableview-bound-value-transform` | libs-gui | test | [#981](https://github.com/gnustep/libs-gui/pull/981) | (none: WorkflowKit uses it from here) |
| `tableview-prototype-identifier` | libs-gui | test | [#1005](https://github.com/gnustep/libs-gui/pull/1005) | (none: UDCalc will use it from here) |
| `scrollview-autohide-reentrancy` | libs-gui | test | not sent yet | (none: UDCalc will use it from here; Gershwin needs its own copy, see NOTES.md) |
| `layoutmanager-sanity-checks` | libs-gui | test | not sent yet | (none: UDCodeKit uses it from here) |
| `layoutmanager-layout-to-point` | libs-gui | test | not sent yet | (none: UDCodeKit uses it from here) |
| `textfield-binding-placeholders` | libs-gui | test | not sent yet | (none: UDQuakeTools uses it from here) |
| `controller-entity-mode` | libs-gui | test | not sent yet (after `arraycontroller-arrange-eagerly`) | (none: Logbook's LBEntityController will drop its entity mode) |
| `quick-click-order` | libs-back | test | not sent yet | (none: UDCodeKit and UDQuakeTools use it from here) |
| `binding-to-many-mutation` | libs-gui | test | not sent yet | (none: UDQuakeTools uses it from here) |
| `controller-selection-markers` | libs-gui | test | not sent yet | (none: bound controls show AppKit's placeholders from here) |
| `controller-to-many-content` | libs-gui | test | not sent yet (after `controller-entity-mode`) | (none: Logbook adds records through it) |
| `controller-to-many-set` | libs-gui | test | not sent yet (after `controller-to-many-content`) | (none: Logbook filters records through it) |
| `controller-value-bindings` | libs-gui | test | not sent yet | (none: Logbook's pick lists bind their order through it) |
| `controller-fetch-sort-keys` | libs-gui | test | not sent yet (after `controller-entity-mode`) | (none: Logbook's pick lists fetch through it) |
| `objectcontroller-deferred-add` | libs-gui | test | not sent yet | (none: Logbook's self-test spins the run loop after Add) |
| `objectcontroller-when-can-add` | libs-gui | test | not sent yet (after `objectcontroller-deferred-add`) | (none: Add and Insert buttons bound to canAdd and canInsert use it from here) |
| `selection-equal-objects` | libs-gui | test | not sent yet | (none: Logbook's array controllers use it from here) |
| `selection-new-content` | libs-gui | test | not sent yet (after `selection-equal-objects`) | (none: Logbook's array controllers use it from here) |
| `popup-selected-object` | libs-gui | test | not sent yet (after `popup-content-bindings`) | (none: Logbook's pop-ups set their objects through it) |
| `font-family-names` | libs-gui | test | not sent yet | (none: RDLKit will use it from here) |
| `cairo-unhinted-metrics` | libs-back | test | not sent yet | (none: RDLKit will use it from here) |
| `cairo-screen-font-size` | libs-back | test | not sent yet | (none: RDLKit will use it from here) |
| `landscape-pdf-pages` | libs-gui and libs-back | test | not sent yet | (none: RDLKit will use it from here) |
| `layoutmanager-font-leading` | libs-gui | test | not sent yet | (none: RDLKit will use it from here) |
| `cairo-dash-lengths` | libs-back | test | not sent yet | (none: RDLKit will use it from here) |
| `modal-stop-from-timer` | libs-gui | test | not sent yet | (none: RDLKit will use it from here) |
| `pdf-ligature-text` | libs-back | test | not sent yet | (none: RDLKit will use it from here) |
| `scrollview-nib-document-origin` | libs-gui | test | not sent yet | (none: RDLKit will use it from here) |
| `splitview-set-position-bounds` | libs-gui | test | not sent yet | (none: RDLKit will use it from here) |
| `control-state-value-signed` | libs-gui | test | not sent yet | (none: RDLKit will use it from here) |
| `urlsession-task-state-signed` | libs-base | test | not sent yet | (none: RDLKit will use it from here) |
| `cairo-window-surface-termination` | libs-back | test | not sent yet | (none: RDLKit will use it from here) |
| `pasteboard-clear-contents` | libs-gui | test | not sent yet | (none: RDLKit will use it from here) |
| `window-sheet-api` | libs-gui | test | not sent yet | (none: RDLKit will use it from here) |
| `colorspace-srgb` | libs-gui | test | not sent yet | (none: RDLKit will use it from here) |
| `cgrectunion-size` | libs-opal | none | [#71](https://github.com/gnustep/libs-opal/pull/71) | GSXFormsKit |
| `freetype-advance-without-size` | libs-opal | test | [#72](https://github.com/gnustep/libs-opal/pull/72) | (none: XFormsKit uses it from here) |
| `cfstring-overrelease` | libs-corebase | none | [#166](https://github.com/gnustep/libs-corebase/pull/166) | gnustep-build |
| `gsunicode-write-name` | libs-corebase | none (a compile error on Windows; the Windows stack build is the check) | not sent yet | (none: the Windows stack uses it from here) |
| `mingw-mode-t` | libdispatch | none (a header that does not compile on MinGW; the Windows stack build is the check) | not sent yet | (none: the Windows stack uses it from here) |
| `mingw-blocksruntime-name` | libdispatch | none (libdispatch.dll does not load on MinGW; the Windows stack check is the test) | not sent yet | (none: the Windows stack uses it from here) |
| `windows-listening-socket-read` | libdispatch | none (GCDWebServer's Windows smoke test is the check: it listens but never accepts without it) | not sent yet | (none: the Windows stack uses it from here) |
| `uuid-secure-coding` | libs-base | test | not sent yet | (none: ODataKit's apps, Logbook first, use it from here) |
| `kvo-nested-value-kept` | libs-base | test | not sent yet | (none: Logbook uses it from here) |
| `tablecolumn-binds-table` | libs-gui | test | not sent yet | (none: Logbook uses it from here) |
| `thread-exit-after-atexit` | libs-base | test | not sent yet | (none: Logbook uses it from here) |
| `xib-custom-view-identifier` | libs-gui | test | not sent yet | (none: Logbook uses it from here) |
| `locale-currency-name` | libs-base | test | not sent yet | (none: Logbook uses it from here) |
| `nsbundle-windows-exe` | libs-base | test | not sent yet | (none: FreeCoreData's CDLauncher has a workaround until the stack has it) |
| `nstask-windows-gui-shown` | libs-base | test | not sent yet | (none: FreeCoreData uses it from here) |
| `pdf-lent-image` | cairo | repro (`pdf-pad-win32.c`) | not sent yet (by hand) | (none: the Windows stack builds cairo with it) |
| `system-font-segoe-ui` | libs-back | test | not sent yet | (none: SimpleNotes uses it from here) |
| `win32-window-icon` | libs-back | test | not sent yet | (none: every Windows app uses it from here) |
| `workspace-open-url-quietly` | libs-gui | test | not sent yet | (none: every app uses it from here) |

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
| ~~`-[NSView dataWithPDFInsideRect:]` never returns on a headless machine~~ | **Wrong: it is real; it became `graphicscontext-backend-recursion`, merged upstream as #978.**  The first pass called it unreproducible because every reproduction written to show it made an `NSApplication` first, which is exactly what hides it.  Run the same code in a tool that makes none -- a report generator -- and it spins for ever |

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
