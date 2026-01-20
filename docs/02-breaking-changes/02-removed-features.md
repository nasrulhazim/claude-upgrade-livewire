# Removed Features

Features that have been removed in Livewire 4.

## Overview

Livewire 4 has not removed any major features from Livewire 3. This is intentional to ensure smooth upgrades.

## No Breaking Removals

The following Livewire 3 features continue to work in Livewire 4:

### Validation

```php
// Property rules - Still works
protected array $rules = [
    'name' => 'required|min:3',
    'email' => 'required|email',
];

// Attribute validation - Still works
#[Validate('required|min:3')]
public string $name = '';

// Custom messages - Still works
protected array $messages = [
    'name.required' => 'Please enter a name',
];
```

### URL State Management

```php
// Query string property - Still works
protected $queryString = [
    'search' => ['except' => ''],
    'page' => ['except' => 1],
];

// URL attribute - Still works
#[Url]
public string $search = '';
```

### Traits

```php
// All traits work unchanged
use WithPagination;
use WithFileUploads;
```

### Lifecycle Methods

```php
// All lifecycle methods work unchanged
public function mount(): void {}
public function hydrate(): void {}
public function dehydrate(): void {}
public function updating($property, $value): void {}
public function updated($property, $value): void {}
public function updatedPropertyName($value): void {}
```

### Layouts

```php
// Layout attribute - Still works
#[Layout('layouts.app')]
class Dashboard extends Component {}

// Layout method - Still works
public function render()
{
    return view('livewire.dashboard')
        ->layout('layouts.app');
}
```

## Legacy Features

These very old patterns from Livewire 2 that were already deprecated in Livewire 3 may not work:

| Feature | Status | Alternative |
|---------|--------|-------------|
| `wire:model.defer` | Use `wire:model` | Default behavior is now deferred |
| `wire:model.lazy` | Use `wire:model.blur` | Triggers on blur |

> **Note**: If you're upgrading from Livewire 2, first upgrade to Livewire 3, then to Livewire 4.

## Next Steps

- [Behavior Changes](03-behavior-changes.md) - How features behave differently
- [Migration Guide](../03-migration-guide/README.md) - Step-by-step upgrade
