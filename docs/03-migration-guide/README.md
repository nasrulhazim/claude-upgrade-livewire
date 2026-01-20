# Migration Guide

Step-by-step instructions for upgrading your application to Livewire 4.

## Table of Contents

### [1. Getting Started](01-getting-started.md)

Prerequisites and initial upgrade steps.

### [2. Application Upgrade](02-application-upgrade.md)

Upgrading a Laravel application to Livewire 4.

### [3. Package Upgrade](03-package-upgrade.md)

Upgrading a Laravel package that depends on Livewire.

### [4. Troubleshooting](04-troubleshooting.md)

Common issues and their solutions.

## Related Documentation

- [Breaking Changes](../02-breaking-changes/README.md)
- [Patterns](../04-patterns/README.md)
- [Testing](../05-testing/README.md)

## Quick Upgrade

For most applications, the upgrade is straightforward:

```bash
# 1. Update composer.json
composer require livewire/livewire:^4.0

# 2. Clear caches
php artisan view:clear
php artisan cache:clear

# 3. Run tests
composer test
```

If tests pass, you're done. See the detailed guides for more complex scenarios.
