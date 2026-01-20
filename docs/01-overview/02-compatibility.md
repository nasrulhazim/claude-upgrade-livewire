# Compatibility

Version requirements and backward compatibility information for Livewire 4.

## Version Requirements

### PHP Version

| Livewire Version | PHP Requirement |
|------------------|-----------------|
| 4.x | PHP 8.1+ |
| 3.x | PHP 8.1+ |

### Laravel Version

| Livewire Version | Laravel Requirement |
|------------------|---------------------|
| 4.x | Laravel 10.x, 11.x, 12.x |
| 3.x | Laravel 10.x, 11.x, 12.x |

### Node.js (for asset compilation)

- Node.js 18.x or higher recommended
- npm 9.x or higher

## Backward Compatibility

Livewire 4 maintains excellent backward compatibility with Livewire 3. Most applications can upgrade with minimal or no code changes.

### Fully Compatible Features

These features work identically in both versions:

#### PHP Attributes

```php
#[Layout('layouts.app')]      // Unchanged
#[Url]                        // Unchanged
#[Validate('required')]       // Unchanged
#[Computed]                   // Unchanged
#[On('event-name')]           // Unchanged
```

#### Blade Directives

```blade
wire:model              <!-- Unchanged -->
wire:model.live         <!-- Unchanged -->
wire:model.blur         <!-- Unchanged -->
wire:click              <!-- Unchanged -->
wire:submit             <!-- Unchanged -->
wire:navigate           <!-- Unchanged -->
wire:confirm            <!-- Unchanged -->
wire:loading            <!-- Unchanged -->
```

#### Component Methods

```php
$this->dispatch('event')           // Unchanged
$this->dispatchTo('component', 'event')  // Unchanged
$this->validate()                  // Unchanged
$this->reset()                     // Unchanged
$this->resetValidation()           // Unchanged
```

#### Validation Patterns

```php
// Property array - Unchanged
protected array $rules = [
    'name' => 'required|min:3',
    'email' => 'required|email',
];

// Attribute validation - Unchanged
#[Validate('required|min:3')]
public string $name = '';
```

#### URL State Management

```php
// Property array - Unchanged
protected $queryString = [
    'search' => ['except' => ''],
    'page' => ['except' => 1],
];

// Attribute - Unchanged
#[Url]
public string $search = '';
```

## Package Compatibility

### First-Party Packages

| Package | Livewire 4 Support |
|---------|-------------------|
| livewire/flux | 2.10+ |
| livewire/volt | Full support |

### Popular Third-Party Packages

Most packages that support Livewire 3 will work with Livewire 4. Check package documentation for specific compatibility notes.

When updating packages:

```json
{
    "require": {
        "livewire/livewire": "^3.0 || ^4.0"
    }
}
```

## Browser Support

Livewire 4 supports all modern browsers:

- Chrome (latest 2 versions)
- Firefox (latest 2 versions)
- Safari (latest 2 versions)
- Edge (latest 2 versions)

> **Note**: Internet Explorer is not supported.

## Next Steps

- [Upgrade Assessment](03-upgrade-assessment.md) - Check your codebase
- [Getting Started](../03-migration-guide/01-getting-started.md) - Begin the upgrade
