# Application Upgrade

Step-by-step guide for upgrading a Laravel application to Livewire 4.

## Step 1: Update Composer Dependency

### Option A: Direct Upgrade

```bash
composer require livewire/livewire:^4.0
```

### Option B: Manual Edit

Edit `composer.json`:

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

## Step 2: Clear Caches

Clear all caches to ensure fresh compilation:

```bash
php artisan view:clear
php artisan cache:clear
php artisan config:clear
php artisan route:clear
```

Or use the optimize command:

```bash
php artisan optimize:clear
```

## Step 3: Run Tests

Execute your test suite:

```bash
# Using Composer script
composer test

# Using Pest
vendor/bin/pest

# Using PHPUnit
vendor/bin/phpunit
```

If all tests pass, proceed to Step 5 (verification).

## Step 4: Update Deprecated Patterns (If Needed)

If you have deprecated patterns, update them:

### Replace emit() with dispatch()

**Find files**:

```bash
grep -r "->emit(" app/ --include="*.php"
```

**Update pattern**:

```php
// Before
$this->emit('event-name');
$this->emit('event-name', $data);

// After
$this->dispatch('event-name');
$this->dispatch('event-name', data: $data);
```

### Replace emitTo() with dispatch()->to()

```php
// Before
$this->emitTo('component-name', 'event-name');

// After
$this->dispatch('event-name')->to('component-name');
```

### Replace emitUp() with dispatch()->up()

```php
// Before
$this->emitUp('event-name', $data);

// After
$this->dispatch('event-name', data: $data)->up();
```

### Replace $listeners with #[On]

```php
// Before
class MyComponent extends Component
{
    protected $listeners = ['event-name' => 'handleEvent'];

    public function handleEvent($data): void
    {
        // Handle event
    }
}

// After
use Livewire\Attributes\On;

class MyComponent extends Component
{
    #[On('event-name')]
    public function handleEvent($data): void
    {
        // Handle event
    }
}
```

## Step 5: Verification

### Run Test Suite Again

```bash
composer test
```

### Run Static Analysis (If Available)

```bash
# PHPStan
vendor/bin/phpstan analyse

# Or using Composer script
composer analyse
```

### Manual Smoke Testing

Test critical Livewire functionality:

- [ ] Component renders correctly
- [ ] Form submissions work
- [ ] Real-time validation works
- [ ] Events dispatch and are received
- [ ] File uploads work (if used)
- [ ] Pagination works (if used)
- [ ] URL state management works (if used)

## Step 6: Update Related Packages

Check if you have Livewire-related packages:

```bash
composer show | grep livewire
```

Common packages to update:

### Flux UI

```bash
composer require livewire/flux:^2.10
```

### Volt

```bash
composer require livewire/volt
```

## Step 7: Commit Changes

Once verified:

```bash
git add .
git commit -m "Upgrade Livewire from 3.x to 4.x

- Updated livewire/livewire to ^4.0
- [List any code changes made]

Co-Authored-By: Claude <noreply@anthropic.com>"
```

## Rollback (If Needed)

If issues occur, rollback to Livewire 3:

```bash
# Restore composer.json
git checkout composer.json composer.lock

# Reinstall dependencies
composer install

# Clear caches
php artisan optimize:clear
```

## Checklist

- [ ] Created backup branch
- [ ] Updated `composer.json`
- [ ] Ran `composer update`
- [ ] Cleared caches
- [ ] Tests pass
- [ ] Updated deprecated patterns (if any)
- [ ] Static analysis passes
- [ ] Manual testing completed
- [ ] Related packages updated
- [ ] Changes committed

## Next Steps

- [Troubleshooting](04-troubleshooting.md) - If you encounter issues
- [Testing](../05-testing/README.md) - Comprehensive testing guide
