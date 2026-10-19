# controller-entity-mode

This patch applies on top of `arraycontroller-arrange-eagerly`: it adds
the deletion of removed objects to `-removeObject:` and `-removeObjects:`,
which that one rewrites. `apply-patches.sh` applies them in that order
(alphabetical), and upstream the two go as one branch, or this one after
that one has merged.

What macOS does that this does not: an array controller in entity mode
that has fetched also follows its context, adding objects of its entity
inserted elsewhere and dropping those deleted elsewhere, from
NSManagedObjectContextObjectsDidChangeNotification. That notification's
name and its user-info keys are different strings in Apple's Core Data and
FreeCoreData (NSObjectsChangedInManagingContextNotification and "inserted"
on macOS, the constants' own names in FreeCoreData), so gnustep-gui cannot
name them without linking Core Data; it needs the exported constants to be
looked up at run time first. Left for another patch.

macOS raises when a delayed fetch finds no context ("Cannot perform
operation without a managed object context"); this does nothing instead.
