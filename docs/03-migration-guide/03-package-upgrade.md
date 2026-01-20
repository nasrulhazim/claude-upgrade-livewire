# Package Upgrade

Guide for upgrading Laravel packages that depend on Livewire to support both versions 3 and 4.

## Overview

When maintaining a package, you typically want to support both Livewire 3 and 4 to give users flexibility in their upgrade timeline.

## Identifying a Package vs Application

Before proceeding, ensure you're working on a package:

| Indicator | Package | Application |
|-----------|---------|-------------|
| `composer.json` type | `library` | `project` |
| Source directory | `src/` | `app/` |
| Has `public/index.php` | No | Yes |
| Uses `PackageServiceProvider` | Usually | No |
| Published on Packagist | Yes | Rarely |

If you're working on an application, see [Application Upgrade](02-application-upgrade.md) instead.

## Step 1: Update Version Constraint

Edit your package's `composer.json`:

```json
{
    "require": {
        "livewire/livewire": "^3.0 || ^4.0"
    }
}
```

> **Note**: Use `||` with spaces for readability.

## Step 2: Check Component Compatibility

Review your Livewire components for patterns that work in both versions.

### Compatible Patterns (No Changes Needed)

These patterns work identically in Livewire 3 and 4:

```php
use Livewire\Attributes\Layout;
use Livewire\Attributes\Url;
use Livewire\Attributes\Validate;
use Livewire\Component;
use Livewire\WithPagination;

#[Layout('layouts.app')]
class MyComponent extends Component
{
    use WithPagination;

    #[Url]
    public string $search = '';

    #[Validate('required|min:3')]
    public string $name = '';

    protected array $rules = [
        'email' => 'required|email',
    ];

    protected $queryString = [
        'search' => ['except' => ''],
    ];

    public function mount(): void
    {
        // Initialize
    }

    public function updatedSearch(): void
    {
        $this->resetPage();
    }

    public function save(): void
    {
        $this->validate();
        // Save logic
    }
}
```

### Event Handling (Works in Both)

Both syntaxes work in Livewire 3 and 4:

```php
// dispatch() - Works in both versions
$this->dispatch('event-name');
$this->dispatch('event-name', data: $value);

// getListeners() - Works in both versions
protected function getListeners(): array
{
    return ['event-name' => 'handleEvent'];
}
```

### Version-Aware Component Registration (Service Provider)

For packages with multiple Livewire components, use version-aware registration in your service provider:

```php
use Livewire\Livewire;
use Spatie\LaravelPackageTools\Package;
use Spatie\LaravelPackageTools\PackageServiceProvider;

class MyPackageServiceProvider extends PackageServiceProvider
{
    public function configurePackage(Package $package): void
    {
        $package
            ->name('my-package')
            ->hasConfigFile()
            ->hasViews();
    }

    public function packageBooted(): void
    {
        $this->registerLivewireComponents();
    }

    protected function registerLivewireComponents(): void
    {
        $version = config('my-package.livewire', 'auto');

        if ($this->shouldUseLivewire4($version)) {
            // Livewire 4: Register by namespace (cleaner, auto-discovers)
            Livewire::addNamespace(
                'my-package',
                classNamespace: 'Vendor\MyPackage\Livewire'
            );
        } else {
            // Livewire 3: Register each component individually
            Livewire::component('my-package::component-a', ComponentA::class);
            Livewire::component('my-package::component-b', ComponentB::class);
            Livewire::component('my-package::component-c', ComponentC::class);
        }
    }

    protected function shouldUseLivewire4(string $version): bool
    {
        return match ($version) {
            'v4' => true,
            'v3' => false,
            default => method_exists(Livewire::getFacadeRoot(), 'addNamespace'),
        };
    }
}
```

### Config File for Version Selection

Add a config option to let users explicitly choose their Livewire version:

```php
// config/my-package.php
return [
    // Livewire version: 'auto', 'v3', or 'v4'
    // 'auto' detects the installed version automatically
    'livewire' => 'auto',
];
```

This allows users to:
- Use `'auto'` (default) - Automatically detect Livewire version
- Use `'v3'` - Force Livewire 3 registration pattern
- Use `'v4'` - Force Livewire 4 registration pattern

### Auto-Detection Logic

The key to auto-detection is checking for Livewire 4-specific features:

```php
protected function shouldUseLivewire4(string $version): bool
{
    return match ($version) {
        'v4' => true,
        'v3' => false,
        // Auto-detect: addNamespace() exists only in Livewire 4
        default => method_exists(Livewire::getFacadeRoot(), 'addNamespace'),
    };
}
```

This approach is more reliable than version string comparison because it tests actual capability.

### Version-Specific Code in Components

If you must use version-specific code:

```php
use Livewire\Livewire;

class MyComponent extends Component
{
    public function someMethod(): void
    {
        // Check Livewire version if needed
        $version = Livewire::VERSION;
        $isV4 = version_compare($version, '4.0.0', '>=');

        if ($isV4) {
            // Livewire 4 specific code
        } else {
            // Livewire 3 specific code
        }
    }
}
```

> **Note**: This should rarely be needed as most component code is compatible.

## Step 3: Update Dependencies

Run composer update:

```bash
composer update livewire/livewire --with-all-dependencies
```

## Step 4: Run Tests

Ensure tests pass with both Livewire versions.

### Testing with Livewire 3

```bash
composer require livewire/livewire:^3.0 --dev
composer test
```

### Testing with Livewire 4

```bash
composer require livewire/livewire:^4.0 --dev
composer test
```

### CI Matrix Testing

Configure your CI to test both versions:

**GitHub Actions example**:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        livewire: ['^3.0', '^4.0']
        php: ['8.2', '8.3']

    steps:
      - uses: actions/checkout@v4

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: ${{ matrix.php }}

      - name: Install dependencies
        run: |
          composer require livewire/livewire:${{ matrix.livewire }} --no-update
          composer install --prefer-dist --no-progress

      - name: Run tests
        run: vendor/bin/pest
```

## Step 5: Run Static Analysis

```bash
composer analyse
```

Ensure no type errors with either Livewire version.

## Step 6: Update Documentation

Update your package README to indicate Livewire 4 support:

```markdown
## Requirements

- PHP 8.1+
- Laravel 10.x, 11.x, or 12.x
- Livewire 3.x or 4.x
```

## Step 7: Tag a Release

```bash
git add .
git commit -m "feat: Add Livewire 4 support

- Updated livewire/livewire constraint to ^3.0 || ^4.0
- Verified compatibility with both versions
- No breaking changes

Co-Authored-By: Claude <noreply@anthropic.com>"

git tag v1.x.x
git push origin main --tags
```

## Example: Real Package Update

Here's a complete example from updating a package:

### Before (composer.json)

```json
{
    "name": "vendor/my-package",
    "require": {
        "livewire/livewire": "^3.0"
    }
}
```

### After (composer.json)

```json
{
    "name": "vendor/my-package",
    "require": {
        "livewire/livewire": "^3.0 || ^4.0"
    }
}
```

## Complete Service Provider Example

Here's a production-ready service provider supporting both Livewire versions:

```php
<?php

namespace Vendor\MyPackage;

use Vendor\MyPackage\Livewire\Browser;
use Vendor\MyPackage\Livewire\Editor;
use Vendor\MyPackage\Livewire\Picker;
use Livewire\Livewire;
use Spatie\LaravelPackageTools\Package;
use Spatie\LaravelPackageTools\PackageServiceProvider;

class MyPackageServiceProvider extends PackageServiceProvider
{
    public function configurePackage(Package $package): void
    {
        $package
            ->name('my-package')
            ->hasConfigFile()
            ->hasViews();
    }

    public function packageBooted(): void
    {
        $this->registerLivewireComponents();
    }

    protected function registerLivewireComponents(): void
    {
        $version = config('my-package.livewire', 'auto');

        if ($this->shouldUseLivewire4($version)) {
            // Livewire 4: Register by namespace
            // Components at src/Livewire/*.php become <livewire:my-package::component-name />
            Livewire::addNamespace(
                'my-package',
                classNamespace: 'Vendor\MyPackage\Livewire'
            );
        } else {
            // Livewire 3: Register each component manually
            Livewire::component('my-package::browser', Browser::class);
            Livewire::component('my-package::editor', Editor::class);
            Livewire::component('my-package::picker', Picker::class);
        }
    }

    protected function shouldUseLivewire4(string $version): bool
    {
        return match ($version) {
            'v4' => true,
            'v3' => false,
            default => method_exists(Livewire::getFacadeRoot(), 'addNamespace'),
        };
    }
}
```

### Config File (config/my-package.php)

```php
<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Livewire Version
    |--------------------------------------------------------------------------
    |
    | Configure which Livewire version's registration pattern to use.
    |
    | Supported: "auto", "v3", "v4"
    | - "auto": Automatically detects installed Livewire version (recommended)
    | - "v3": Force Livewire 3 component registration
    | - "v4": Force Livewire 4 namespace registration
    |
    */
    'livewire' => 'auto',
];
```

### Usage in Blade Templates

Both versions work identically in templates:

```blade
{{-- These work in both Livewire 3 and 4 --}}
<livewire:my-package::browser />
<livewire:my-package::editor :content="$content" />
<livewire:my-package::picker @selected="handleSelection" />
```

## Checklist

- [ ] Updated version constraint to `^3.0 || ^4.0`
- [ ] Reviewed components for compatibility
- [ ] Tests pass with Livewire 3
- [ ] Tests pass with Livewire 4
- [ ] Static analysis passes
- [ ] CI matrix updated for both versions
- [ ] Documentation updated
- [ ] New version tagged and released

## Next Steps

- [Troubleshooting](04-troubleshooting.md) - Common issues
- [Testing](../05-testing/README.md) - Testing guide
