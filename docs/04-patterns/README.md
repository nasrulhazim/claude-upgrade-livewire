# Patterns

Common migration patterns with before/after code examples.

## Table of Contents

### [1. Event Patterns](01-event-patterns.md)

Migrating event emission and listening patterns.

### [2. Validation Patterns](02-validation-patterns.md)

Validation approaches in Livewire 4.

### [3. State Management](03-state-management.md)

URL state, computed properties, and component state.

## Related Documentation

- [Breaking Changes](../02-breaking-changes/README.md)
- [Migration Guide](../03-migration-guide/README.md)

## Quick Reference

### Events

```php
// Before (deprecated)
$this->emit('event');

// After
$this->dispatch('event');
```

### Listeners

```php
// Before
protected $listeners = ['event' => 'handler'];

// After
#[On('event')]
public function handler() {}
```

### Computed

```php
// Before
public function getItemsProperty() {}

// After
#[Computed]
public function items() {}
```
