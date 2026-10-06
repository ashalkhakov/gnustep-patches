# Why this one is named the way it is

`Scripts/apply-patches.sh` applies a project's patches in the order the
shell globs them, which is alphabetical, and this patch's context includes
lines that `predicate-subquery` adds — `+expressionForSubquery:…` and
`-predicate` in `NSExpression.h`. Named `expression-…` it sorted before
that patch and its two header hunks were rejected; named `selector-…` it
sorts after it and the set applies clean.

Nothing else here depends on where it falls, so if `predicate-subquery`
ever goes upstream and leaves this repository, the name can go back to
whatever reads best.
