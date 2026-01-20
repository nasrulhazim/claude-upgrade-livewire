# Testing

How to verify your upgrade and ensure components work correctly.

## Table of Contents

### [1. Unit Testing](01-unit-testing.md)

Testing individual Livewire components.

### [2. Integration Testing](02-integration-testing.md)

Testing component interactions.

## Related Documentation

- [Migration Guide](../03-migration-guide/README.md)
- [Troubleshooting](../03-migration-guide/04-troubleshooting.md)

## Quick Verification

After upgrading, run these checks:

```bash
# 1. Run test suite
composer test

# 2. Run static analysis
composer analyse

# 3. Clear caches
php artisan optimize:clear

# 4. Manual smoke test
php artisan serve
```

## Testing Checklist

- [ ] All existing tests pass
- [ ] Component renders correctly
- [ ] Properties bind correctly
- [ ] Actions trigger correctly
- [ ] Events dispatch and receive
- [ ] Validation works
- [ ] URL state persists
