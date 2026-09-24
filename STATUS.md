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

| Fix | Upstream | Repro | PR | Carried by |
| --- | --- | --- | --- | --- |
| `predicate-equality-options` | libs-base | yes | — | gnustep-coredata |
| `expression-self-type` | libs-base | yes | — | gnustep-coredata |
| `expression-binary-coding` | libs-base | yes | — | gnustep-coredata |
| `predicate-subquery` | libs-base | yes | — | gnustep-coredata |
| `dateformatter-cell-behavior` | libs-base | yes | — | gnustep-coredata |
| `keyedarchiver-secure-coding` | libs-base | yes | — | gnustep-coredata |
| `nsxmlelement-addattribute-value-doc` | libs-base | yes | — | GSXFormsKit |
| `sax-handler-calloc` | libs-base | valgrind | — | RDLKit |
| `xmlns-attribute` | libs-base | yes | — | RDLKit |
| `arraycontroller-selection-kvo` | libs-gui | yes | — | gnustep-coredata |
| `tableview-column-autoresizing-style` | libs-gui | no | — | gnustep-coredata |
| `xib-date-picker` | libs-gui | no | — | gnustep-coredata |
| `gscstableau-removerow-use-after-free` | libs-gui | yes | — | GSXFormsKit, HomeRow |
| `action-sender-lifetime` | libs-gui | yes | — | GSXFormsKit, HomeRow |
| `tracking-walk-retains-subviews` | libs-gui | yes | — | GSXFormsKit, HomeRow |
| `pdf-print-operation` | libs-gui | yes | — | RDLKit |
| `cgrectunion-size` | libs-opal | no | — | GSXFormsKit |
| `cfstring-overrelease` | libs-corebase | no | — | gnustep-build |
| `keep-nib-textfield-bezel` | gershwin-eau-theme | no | — | gnustep-coredata |
| `nsalert-window-ownership` | gershwin-eau-theme | no | — | gnustep-build |

Re-run that check before sending anything: `Scripts/apply-patches.sh` on a
fresh checkout is the quickest form of it.

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
