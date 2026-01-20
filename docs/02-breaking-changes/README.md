# Breaking Changes

Complete reference of API changes, deprecations, and removed features in Livewire 4.

## Table of Contents

### [1. Deprecations](01-deprecations.md)

Features that are deprecated but still work.

### [2. Removed Features](02-removed-features.md)

Features that have been removed entirely.

### [3. Behavior Changes](03-behavior-changes.md)

Changes in how existing features behave.

## Related Documentation

- [Migration Guide](../03-migration-guide/README.md)
- [Patterns](../04-patterns/README.md)

## Summary

Livewire 4 has very few breaking changes. Most Livewire 3 code works without modification.

### Impact Assessment

| Category | Count | Severity |
|----------|-------|----------|
| Deprecations | 3 | Low - Still work |
| Removed | 0 | None |
| Behavior Changes | 1 | Low |

### Key Points

1. **emit() methods are deprecated** - Use `dispatch()` instead (still works)
2. **$listeners property** - Use `#[On]` attribute (still works)
3. **Most patterns unchanged** - Attributes, directives, traits all work
