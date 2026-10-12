# scrollview-autohide-reentrancy

Found in UDCalc (github.com/ashalkhakov/UDCalc): its RPN stack is a
view-based NSTableView, `columnAutoresizingStyle="lastColumnOnly"`, in an
autohiding scroll view. Once `tableview-prototype-identifier` let that nib
load at all, the app crashed at launch under the default GNUstep theme with
a stack of `-tile` / `-[NSClipView setFrame:]` / `-reflectScrolledClipView:`
/ `-_autohideScrollers`. Logging each decision showed the table always 2
points wider than its clip view (548 in 546 without scrollers, 529 in 527
with the vertical one) and the decision flipping between "both" and
"neither" 5,688 times each before the stack ran out. Under Gershwin's Eau
theme the same nib does not oscillate.

The 2 points come from the table's own `-superviewFrameChanged:` heuristic,
which `tableview-column-autoresizing-style` replaces; with that patch the
table may well fit exactly. The guard is still the right fix in
NSScrollView: any document view that follows the clip view can make the
nested decision undo the outer one, which is what the test models.

## Gershwin

Gershwin pins libs-gui (8f804fd52 on `gershwin-developer` dev) and carries
`scrollview-autohide-subpixel.patch`, a 1-point slack in the same function.
That slack does not stop this case (the test fails with it applied: 402
resizes), and it inserts a line directly below the hunk here, so this patch
does not apply with `-F0` on top of Gershwin's tree. A copy for Gershwin
needs regenerating against its patched `Source/NSScrollView.m`; the change
itself is the same.
