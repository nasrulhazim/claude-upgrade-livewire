# Documentation

Comprehensive guide for upgrading Livewire from version 3 to version 4.

## Overview

Livewire 4 introduces performance improvements and new features while maintaining backward compatibility with most Livewire 3 patterns. This documentation covers everything you need for a successful upgrade.

## Documentation Structure

### [01. Overview](01-overview/README.md)

Introduction to Livewire 4, new features, and what to expect from the upgrade process.

### [02. Breaking Changes](02-breaking-changes/README.md)

Complete reference of API changes, deprecations, and removed features.

### [03. Migration Guide](03-migration-guide/README.md)

Step-by-step instructions for upgrading your application and packages.

### [04. Patterns](04-patterns/README.md)

Common migration patterns with before/after code examples.

### [05. Testing](05-testing/README.md)

How to verify your upgrade and ensure components work correctly.

## Quick Start

New to the upgrade? Start with [Getting Started](03-migration-guide/01-getting-started.md).

## Finding Information

- **What's new**: Check [Overview](01-overview/README.md) section
- **What changed**: Check [Breaking Changes](02-breaking-changes/README.md) section
- **How to upgrade**: Check [Migration Guide](03-migration-guide/README.md) section
- **Code examples**: Check [Patterns](04-patterns/README.md) section
- **Verification**: Check [Testing](05-testing/README.md) section

## Upgrade Checklist

Use this checklist to track your upgrade progress:

- [ ] Review breaking changes
- [ ] Update `composer.json` version constraint
- [ ] Run `composer update livewire/livewire`
- [ ] Update deprecated patterns (if any)
- [ ] Run test suite
- [ ] Run static analysis
- [ ] Manual smoke testing
