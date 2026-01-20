# Upgrade Assessment

How to assess your codebase readiness before upgrading to Livewire 4.

## Quick Assessment

Run these commands to understand your Livewire usage:

### Count Livewire Components

```bash
# Count PHP components
find app -name "*.php" -exec grep -l "extends Component" {} \; | wc -l

# Or if using a package structure
find src -name "*.php" -exec grep -l "extends Component" {} \; | wc -l
```

### Find Livewire Blade Files

```bash
# Count Livewire blade views
find resources/views/livewire -name "*.blade.php" | wc -l
```

### Check for Deprecated Patterns

```bash
# Check for emit (deprecated, use dispatch)
grep -r "->emit(" app/ --include="*.php"
grep -r "->emitTo(" app/ --include="*.php"
grep -r "->emitUp(" app/ --include="*.php"

# Check for $listeners property (use #[On] or getListeners())
grep -r "protected \$listeners" app/ --include="*.php"
```

## Compatibility Checklist

### Low Risk Patterns (No Changes Needed)

Check if your codebase uses these patterns - they work unchanged:

- [ ] `#[Layout]` attribute for layouts
- [ ] `#[Url]` attribute for URL state
- [ ] `#[Validate]` attribute for validation
- [ ] `$this->dispatch()` for events
- [ ] `wire:model.live` directive
- [ ] `wire:navigate` for SPA navigation
- [ ] `wire:confirm` for confirmations
- [ ] `WithPagination` trait
- [ ] `WithFileUploads` trait
- [ ] `protected array $rules` for validation
- [ ] `protected $queryString` for URL state
- [ ] `mount()` lifecycle method
- [ ] `updated()` lifecycle methods

### Patterns to Review

These patterns may need attention:

#### Event Dispatching

**Livewire 3 (deprecated)**:

```php
// These still work but are deprecated
$this->emit('eventName');
$this->emitTo('component', 'eventName');
$this->emitUp('eventName');
```

**Livewire 4 (recommended)**:

```php
// Use dispatch instead
$this->dispatch('eventName');
$this->dispatch('eventName')->to('component');
$this->dispatch('eventName')->up();
```

#### Event Listeners

**Livewire 3 (still works)**:

```php
protected $listeners = ['eventName' => 'handleEvent'];

// Or method
protected function getListeners(): array
{
    return ['eventName' => 'handleEvent'];
}
```

**Livewire 4 (recommended)**:

```php
use Livewire\Attributes\On;

#[On('eventName')]
public function handleEvent(): void
{
    // Handle event
}
```

## Risk Assessment Matrix

| Pattern | Risk Level | Action Required |
|---------|------------|-----------------|
| `#[Layout]`, `#[Url]`, `#[Validate]` | None | No changes |
| `$this->dispatch()` | None | No changes |
| `wire:model.live` | None | No changes |
| `protected $rules` | None | No changes |
| `protected $queryString` | None | No changes |
| `WithPagination` | None | No changes |
| `$this->emit()` | Low | Update to `dispatch()` |
| `$listeners` property | Low | Consider `#[On]` |
| Custom JavaScript | Medium | Test thoroughly |
| Third-party packages | Medium | Check compatibility |

## Pre-Upgrade Checklist

Before starting the upgrade:

### 1. Backup Your Code

```bash
git checkout -b livewire-4-upgrade
```

### 2. Document Current State

```bash
# Save current test results
composer test > pre-upgrade-tests.log

# Save current static analysis
composer analyse > pre-upgrade-analysis.log
```

### 3. Review Dependencies

Check `composer.json` for packages that depend on Livewire:

```bash
composer depends livewire/livewire
```

### 4. Run Full Test Suite

```bash
# Ensure all tests pass before upgrading
composer test
```

### 5. Check Package Documentation

For each Livewire-dependent package, check if it supports Livewire 4.

## Estimation Guide

### Small Application (< 10 components)

- **Upgrade time**: 15-30 minutes
- **Risk**: Low
- **Testing**: Basic smoke testing

### Medium Application (10-50 components)

- **Upgrade time**: 1-2 hours
- **Risk**: Low to Medium
- **Testing**: Full test suite + manual testing

### Large Application (50+ components)

- **Upgrade time**: 2-4 hours
- **Risk**: Medium
- **Testing**: Full test suite + comprehensive manual testing

### Package/Library

- **Upgrade time**: 30 minutes - 1 hour
- **Risk**: Low
- **Testing**: Full test suite
- **Constraint**: Use `^3.0 || ^4.0` to support both versions

## Next Steps

- [Breaking Changes](../02-breaking-changes/README.md) - Review all changes
- [Getting Started](../03-migration-guide/01-getting-started.md) - Begin upgrade
