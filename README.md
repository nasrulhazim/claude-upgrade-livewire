# Livewire 3 to 4 Upgrade Guide

A comprehensive guide for upgrading Laravel Livewire from version 3 to version 4. This documentation provides step-by-step instructions, breaking changes, migration patterns, and best practices.

## Features

- **Breaking Changes Reference** - Complete list of deprecated and changed APIs
- **Migration Patterns** - Code examples for updating common patterns
- **Compatibility Checklist** - Verify your codebase is ready
- **Testing Guide** - Ensure your components work after upgrade
- **Package Compatibility** - Guide for updating packages that depend on Livewire

## Quick Start

### Prerequisites

- PHP 8.1 or higher
- Laravel 10, 11, or 12
- Livewire 3.x currently installed

### Basic Upgrade

```bash
# Update composer.json
composer require livewire/livewire:^4.0

# Clear caches
php artisan view:clear
php artisan cache:clear
```

## Documentation

See the [full documentation](docs/README.md) for detailed upgrade instructions.

### Quick Links

- [Overview](docs/01-overview/README.md) - What's new in Livewire 4
- [Breaking Changes](docs/02-breaking-changes/README.md) - API changes and deprecations
- [Migration Guide](docs/03-migration-guide/README.md) - Step-by-step upgrade process
- [Patterns](docs/04-patterns/README.md) - Common migration patterns
- [Testing](docs/05-testing/README.md) - Verifying your upgrade

## Livewire 4 Highlights

### New Features

- Improved performance with optimized rendering
- Enhanced TypeScript support
- Better error messages and debugging
- Streamlined attribute syntax

### Backward Compatible

Many Livewire 3 patterns still work in Livewire 4:

- `#[Layout]`, `#[Url]`, `#[Validate]` attributes
- `$this->dispatch()` for events
- `wire:model.live`, `wire:navigate`, `wire:confirm` directives
- `WithPagination`, `WithFileUploads` traits
- `protected $rules` array validation
- `protected $queryString` for URL state
- Lifecycle hooks (`mount`, `updated`, `updating`)

## Version Compatibility

| Livewire | PHP | Laravel |
|----------|-----|---------|
| 4.x | 8.1+ | 10.x, 11.x, 12.x |
| 3.x | 8.1+ | 10.x, 11.x, 12.x |

## Installation

### For Claude Code Users

Copy the upgrade guide to your Claude commands:

```bash
cp docs/upgrade-livewire.md ~/.claude/commands/
```

Then use `/upgrade-livewire` in any project.

### Manual Reference

Browse the `docs/` directory for detailed documentation.

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Follow the documentation standards
4. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Resources

- [Livewire Official Documentation](https://livewire.laravel.com/docs)
- [Livewire GitHub Repository](https://github.com/livewire/livewire)
- [Laravel Documentation](https://laravel.com/docs)

---

**Made for the Laravel and Claude Code community**
