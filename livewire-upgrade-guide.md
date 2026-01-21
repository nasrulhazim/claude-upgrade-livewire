# Livewire 3 to 4 Upgrade Guide

> **Version**: 1.0.0
> **Last Updated**: 2026-01-21
> **Applies To**: Laravel applications and packages using Livewire

## Overview

This guide covers upgrading from Livewire 3 to Livewire 4. The upgrade is straightforward as Livewire 4 maintains excellent backward compatibility with Livewire 3.

## Quick Upgrade

For most projects, upgrading is simple:

```bash
# 1. Update dependency
composer require livewire/livewire:^4.0

# 2. Clear caches
php artisan optimize:clear

# 3. Run tests
composer test
```

## Version Requirements

| Requirement | Version |
|-------------|---------|
| PHP | 8.1+ |
| Laravel | 10.x, 11.x, 12.x |
| Livewire (current) | 3.x |

## Backward Compatible Features

These features work identically in both versions:

### PHP Attributes

```php
use Livewire\Attributes\Layout;
use Livewire\Attributes\Url;
use Livewire\Attributes\Validate;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;

#[Layout('layouts.app')]
class MyComponent extends Component
{
    #[Url]
    public string $search = '';

    #[Validate('required|min:3')]
    public string $name = '';

    #[Computed]
    public function filteredItems(): array
    {
        return $this->items->filter(...);
    }

    #[On('item-created')]
    public function handleItemCreated(): void
    {
        // Handle event
    }
}
```

### Blade Directives

```blade
{{-- Model binding --}}
<input wire:model="name">
<input wire:model.live="search">
<input wire:model.blur="email">
<input wire:model.live.debounce.300ms="query">

{{-- Actions --}}
<button wire:click="save">Save</button>
<button wire:click.prevent="submit">Submit</button>

{{-- Navigation --}}
<a wire:navigate href="/dashboard">Dashboard</a>

{{-- Confirmation --}}
<button wire:click="delete" wire:confirm="Are you sure?">Delete</button>

{{-- Loading states --}}
<div wire:loading>Loading...</div>
```

### Validation

```php
// Property rules array
protected array $rules = [
    'name' => 'required|min:3',
    'email' => 'required|email',
];

// Custom messages
protected array $messages = [
    'name.required' => 'Please enter a name',
];
```

### URL State Management

```php
// Query string property
protected $queryString = [
    'search' => ['except' => ''],
    'page' => ['except' => 1],
];
```

### Traits

```php
use WithPagination;
use WithFileUploads;
```

### Lifecycle Methods

```php
public function mount(): void {}
public function hydrate(): void {}
public function updating($property, $value): void {}
public function updated($property, $value): void {}
public function updatedPropertyName($value): void {}
```

## Deprecated Patterns

These patterns still work but should be updated:

### Event Emission

**Before (deprecated)**:

```php
$this->emit('event-name');
$this->emit('event-name', $data);
$this->emitTo('component', 'event-name');
$this->emitUp('event-name');
$this->emitSelf('event-name');
```

**After (recommended)**:

```php
$this->dispatch('event-name');
$this->dispatch('event-name', data: $data);
$this->dispatch('event-name')->to('component');
$this->dispatch('event-name')->up();
$this->dispatch('event-name')->self();
```

### Event Listeners

**Before (still works)**:

```php
protected $listeners = [
    'event-name' => 'handleEvent',
];
```

**After (recommended)**:

```php
use Livewire\Attributes\On;

#[On('event-name')]
public function handleEvent(): void {}
```

## Routing Changes (Livewire 4)

### Full-Page Component Routing

Livewire 4 introduces `Route::livewire()` for full-page components:

**Livewire 3**:

```php
Route::get('/dashboard', Dashboard::class);
```

**Livewire 4**:

```php
Route::livewire('/dashboard', Dashboard::class);
```

The old `Route::get()` still works but `Route::livewire()` is required for single-file and multi-file components.

### Package Routing with Namespaces

When using `Livewire::addNamespace()`, routes must use string component names:

```php
// Wrong - will cause "Component not found" error
Route::livewire('/dashboard', Dashboard::class);

// Correct - use namespaced component name
Route::livewire('/dashboard', 'my-package::dashboard');
```

## Standardize on Double Colon (::) Notation (Packages)

**RECOMMENDED**: Use `::` (double colon) notation for **both** Livewire 3 and Livewire 4 component registration. This ensures Blade views work consistently across both versions without any changes.

### Why Standardize?

| Approach | Livewire 3 Registration | Livewire 4 Registration | Blade Views |
|----------|------------------------|------------------------|-------------|
| **Old (inconsistent)** | `pkg.component` | `pkg::component` | Must change |
| **New (standardized)** | `pkg::component` | `pkg::component` | No changes needed |

### ServiceProvider Registration

```php
protected function registerLivewireComponents(): void
{
    $version = config('my-package.livewire', 'auto');

    if ($this->shouldUseLivewire4($version)) {
        // Livewire 4: Register by namespace
        Livewire::addNamespace('my-package', classNamespace: 'Vendor\MyPackage\Livewire');
    } else {
        // Livewire 3: Register individually (using :: notation for consistency!)
        Livewire::component('my-package::dashboard', Dashboard::class);
        Livewire::component('my-package::create-workflow', CreateWorkflow::class);
        Livewire::component('my-package::edit-workflow', EditWorkflow::class);
    }
}
```

### Blade Views (Works for Both Versions)

```blade
{{-- These work with BOTH Livewire 3 and 4 when using :: notation --}}
@livewire('my-package::create-workflow')
@livewire('my-package::edit-workflow', ['item' => $item])
@livewire('my-package::manage-metadata', ['item' => $item], key('meta-' . $item->id))
<livewire:my-package::dashboard />
```

### Common Error

```
Livewire\Exceptions\ComponentNotFoundException
Unable to find component: [my-package.create-workflow]
```

This error occurs when there's a mismatch between registration and Blade view naming.

### Migration Steps

1. **Update ServiceProvider**: Change Livewire 3 registration from `.` to `::`
2. **Update Blade views**: Change all `@livewire()` and `<livewire:>` calls from `.` to `::`

### Find and Replace Commands

```bash
# Find dot notation in Blade views
grep -r "@livewire('my-package\." resources/views/ --include="*.blade.php"
grep -r "<livewire:my-package\." resources/views/ --include="*.blade.php"

# Find dot notation in ServiceProvider
grep -r "Livewire::component('my-package\." src/ --include="*.php"

# Batch replace in Blade views (macOS/BSD sed)
find resources/views -name "*.blade.php" -exec sed -i '' "s/@livewire('my-package\./@livewire('my-package::/g" {} \;
find resources/views -name "*.blade.php" -exec sed -i '' "s/<livewire:my-package\./<livewire:my-package::/g" {} \;

# Batch replace in ServiceProvider (macOS/BSD sed)
sed -i '' "s/Livewire::component('my-package\./Livewire::component('my-package::/g" src/*ServiceProvider.php

# Batch replace (GNU/Linux sed - no '' after -i)
find resources/views -name "*.blade.php" -exec sed -i "s/@livewire('my-package\./@livewire('my-package::/g" {} \;
sed -i "s/Livewire::component('my-package\./Livewire::component('my-package::/g" src/*ServiceProvider.php
```

## Application Upgrade Steps

### 1. Create Backup Branch

```bash
git checkout -b livewire-4-upgrade
```

### 2. Update Composer

```bash
composer require livewire/livewire:^4.0
```

Or edit `composer.json`:

```json
{
    "require": {
        "livewire/livewire": "^4.0"
    }
}
```

Then run:

```bash
composer update livewire/livewire --with-all-dependencies
```

### 3. Clear Caches

```bash
php artisan optimize:clear
```

### 4. Run Tests

```bash
composer test
```

### 5. Update Deprecated Patterns (Optional)

Find and update deprecated patterns:

```bash
# Find emit usage
grep -r "->emit(" app/ --include="*.php"

# Find $listeners
grep -r "protected \$listeners" app/ --include="*.php"
```

### 6. Manual Testing

Test critical functionality:

- Component rendering
- Form submissions
- Real-time validation
- Event handling
- File uploads
- Pagination

## Package Upgrade Steps

### 1. Update Version Constraint

```json
{
    "require": {
        "livewire/livewire": "^3.0 || ^4.0"
    }
}
```

### 2. Run Composer Update

```bash
composer update livewire/livewire --with-all-dependencies
```

### 3. Test Both Versions

```bash
# Test with Livewire 3
composer require livewire/livewire:^3.0 --dev
composer test

# Test with Livewire 4
composer require livewire/livewire:^4.0 --dev
composer test
```

### 4. Update CI

```yaml
strategy:
  matrix:
    livewire: ['^3.0', '^4.0']
```

## Troubleshooting

### Dependency Conflicts

```bash
composer why-not livewire/livewire 4.0
```

### Component Not Found

```bash
php artisan view:clear
```

### Component Not Found with Package Namespace

If you see an error like:

```
Unable to find component: [my-package.create-workflow]
```

This means your Blade views are using dot notation (`.`) but your package uses `Livewire::addNamespace()` which requires double colon notation (`::`).

**Fix**: Update all `@livewire()` calls and `<livewire:>` tags:

```blade
{{-- Wrong --}}
@livewire('my-package.create-workflow')

{{-- Correct --}}
@livewire('my-package::create-workflow')
```

### Events Not Firing

Ensure event names match exactly between dispatcher and listener.

### Tests Failing

Check for deprecated `emit()` calls in test assertions.

## Checklist

### Application

- [ ] Created backup branch
- [ ] Updated composer.json
- [ ] Ran composer update
- [ ] Cleared caches
- [ ] Tests pass
- [ ] Updated deprecated patterns
- [ ] Updated full-page component routes to use `Route::livewire()` (if using Livewire 4 only)
- [ ] Manual testing completed

### Package

- [ ] Updated version constraint to `^3.0 || ^4.0`
- [ ] Added version-aware component registration
- [ ] **Standardized Livewire 3 registration to use `::` notation** (e.g., `Livewire::component('pkg::component', ...)`)
- [ ] Added version-aware routing for full-page components
- [ ] Updated all `@livewire()` directives to use `::` notation (e.g., `my-package::component`)
- [ ] Updated all `<livewire:>` tags to use `::` notation
- [ ] Tests pass with Livewire 3
- [ ] Tests pass with Livewire 4
- [ ] CI updated for both versions
- [ ] Documentation updated
- [ ] New version released

## Resources

- [Livewire Documentation](https://livewire.laravel.com/docs)
- [Livewire GitHub](https://github.com/livewire/livewire)
- [Laravel Documentation](https://laravel.com/docs)

---

**Questions?** This guide is maintained at [github.com/nasrulhazim/claude-upgrade-to-livewire-4](https://github.com/nasrulhazim/claude-upgrade-to-livewire-4)
