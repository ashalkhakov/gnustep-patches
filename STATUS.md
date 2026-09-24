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
| `arraycontroller-selection-kvo` | libs-gui | program | — | gnustep-coredata |
| `tableview-column-autoresizing-style` | libs-gui | none | — | gnustep-coredata |
| `xib-date-picker` | libs-gui | none | — | gnustep-coredata |
| `gscstableau-removerow-use-after-free` | libs-gui | program | — | GSXFormsKit, HomeRow |
| `action-sender-lifetime` | libs-gui | program | — | GSXFormsKit, HomeRow |
| `tracking-walk-retains-subviews` | libs-gui | program | — | GSXFormsKit, HomeRow |
| `pdf-print-operation` | libs-gui | program | — | RDLKit |
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

Writing the tests found one bug in the patches themselves: the secure-coding
patch called `+supportsSecureCoding` on a class that need not implement it,
so refusing a non-secure object aborted instead of reporting an error.  It
now asks whether the class responds first.

## Done, and still carried somewhere

These are fixed upstream.  The copies are dead weight and should be deleted
along with the lines that apply them.

| Fix | Upstream | What happened | Delete from |
| --- | --- | --- | --- |
| `tableview-selection-push` | libs-gui | merged; the patch reverse-applies to master | `gnustep-build/Scripts/patches/`, and its apply line in `Scripts/build-gnustep.sh` |
| `tableview-selection-push` (older draft) | libs-gui | superseded by the revision that merged; applies neither way now | `UDQuakeTools/Scripts/`, and the PENDING note in `Scripts/gnustep-patch-repros/README.md` |
| `arraycontroller-selection-init` | libs-gui | master already initialises `_selection_indexes` in `-initWithCoder:`; only the explanatory comment differs | `gnustep-build/Scripts/patches/`, and its apply line |

## Duplicates to retire

`gscstableau-removerow-use-after-free`, `action-sender-lifetime` and
`tracking-walk-retains-subviews` exist byte-for-byte in both `GSXFormsKit`
and `HomeRow`.  HomeRow's README says they were copied unchanged and that it
does not knowingly depend on them.  Both should consume this repository
instead of holding copies.
