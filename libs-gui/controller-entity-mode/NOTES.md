# controller-entity-mode

This patch applies on top of `arraycontroller-arrange-eagerly`: it adds
the deletion of removed objects to `-removeObject:` and `-removeObjects:`,
which that one rewrites. `apply-patches.sh` applies them in that order
(alphabetical), and upstream the two go as one branch, or this one after
that one has merged.

Following the context is matched against AppKit on macOS 15 with Core
Data's in-memory store. Once it has fetched (`-fetch:` or
`-fetchWithRequest:merge:error:`), whatever its
`automaticallyPreparesContent`, an array controller:

- adds inserted objects of its entity or a subentity that match its fetch
  predicate, once each, whether or not it inserted them itself;
- drops deleted and invalidated objects;
- adds updated objects that now match and drops updated members that no
  longer do, which includes an object it added with `add:` that does not
  match;
- leaves refreshed objects alone, even a member that no longer matches;
- empties its content on invalidatedAll (a context's `-reset`), and does
  not refetch;
- then rearranges, keeping the selected objects selected (not selecting
  what was added, whatever `selectsInsertedObjects` says); a selected
  object that goes leaves the first selected.

A member updated without leaving its predicate is not rearranged. A
controller that has not fetched follows nothing, nor does one whose
content is bound. A new context is followed in place of the old one,
without a refetch. An object controller keeps its content while others are
inserted, drops it when it is deleted or no longer matches, and with no
content takes the first matching object inserted or updated.

AppKit observes a private notification of Core Data's,
`_NSObjectsChangedInManagingContextPrivateNotification`, posted just before
the public one with the same keys; a public one posted by hand changes
nothing there. gnustep-gui observes the public one,
`NSObjectsChangedInManagingContextNotification`, and finds its keys by
value. Those are Apple's values, and FreeCoreData's from
[FreeCoreData#90](https://github.com/ashalkhakov/FreeCoreData/pull/90); before that,
FreeCoreData used the constants' names as values, and a controller over it
follows nothing.

FreeCoreData does not post invalidatedAll on `-reset`, so over it a
controller keeps its objects when its context is reset.

macOS raises when a delayed fetch finds no context ("Cannot perform
operation without a managed object context"); this does nothing instead.
