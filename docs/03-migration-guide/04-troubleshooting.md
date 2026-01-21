# Troubleshooting

Common issues and their solutions when upgrading to Livewire 4.

## Composer Issues

### Dependency Conflicts

**Error**:

```text
Your requirements could not be resolved to an installable set of packages.
```

**Solution**:

1. Check which packages conflict:

```bash
composer why-not livewire/livewire 4.0
```

2. Update conflicting packages:

```bash
composer update package/name livewire/livewire --with-all-dependencies
```

3. If a package doesn't support Livewire 4, check for updates or alternatives.

### Package Requires Older Livewire

**Error**:

```text
package/name requires livewire/livewire ^3.0 -> found livewire/livewire[v4.0.0]
```

**Solution**:

1. Check if package has a newer version:

```bash
composer outdated package/name
```

2. Update the package:

```bash
composer update package/name
```

3. If no update available, contact package maintainer or fork and update.

## Component Issues

### Component Not Found

**Error**:

```text
Unable to find component: [component-name]
```

**Solution**:

1. Clear view cache:

```bash
php artisan view:clear
```

2. Verify component registration:

```php
// Check if component is registered
Livewire::component('component-name', ComponentClass::class);
```

3. Check namespace and class name match.

4. **For packages using `Route::livewire()` with `Livewire::addNamespace()`**:

   When using namespace-based registration, `Route::livewire()` must use the string component name, not the class reference:

   ```php
   // Wrong - causes "Component not found" error
   Route::livewire('/dashboard', Dashboard::class);

   // Correct - use namespaced component name
   Route::livewire('/dashboard', 'my-package::dashboard');
   ```

   The component name follows kebab-case convention:
   - `Dashboard` → `my-package::dashboard`
   - `UserIndex` → `my-package::user-index`
   - `WorkflowShow` → `my-package::workflow-show`

### Property Not Reactive

**Symptom**: Property changes but view doesn't update.

**Solution**:

1. Ensure property is public:

```php
// Wrong - private/protected won't be reactive
private string $name = '';

// Correct
public string $name = '';
```

2. For computed properties, use `#[Computed]`:

```php
use Livewire\Attributes\Computed;

#[Computed]
public function fullName(): string
{
    return "{$this->firstName} {$this->lastName}";
}
```

### Events Not Firing

**Symptom**: `dispatch()` called but listener not triggered.

**Solution**:

1. Verify event names match exactly:

```php
// Dispatcher
$this->dispatch('user-created');  // lowercase, hyphenated

// Listener
#[On('user-created')]  // Must match exactly
public function handleUserCreated(): void {}
```

2. Check component is mounted when event fires.

3. For cross-component events, ensure both components are on the page.

### Validation Not Working

**Symptom**: Validation rules not being applied.

**Solution**:

1. Ensure `validate()` is called:

```php
public function save(): void
{
    $this->validate();  // Must call this
    // Save logic
}
```

2. Check rule syntax:

```php
// Property rules
protected array $rules = [
    'name' => 'required|min:3',  // Correct
    'name' => ['required', 'min:3'],  // Also correct
];

// Or attribute
#[Validate('required|min:3')]
public string $name = '';
```

## JavaScript Issues

### Alpine.js Conflicts

**Symptom**: Alpine directives not working.

**Solution**:

1. Ensure Alpine is loaded once (Livewire includes it):

```html
<!-- Don't include Alpine separately if using Livewire -->
<!-- <script src="alpine.js"></script> -->

@livewireScripts
```

2. Check for JavaScript errors in console.

### $wire Not Available

**Symptom**: `$wire is not defined` in Alpine.

**Solution**:

1. Ensure code is inside Livewire component:

```blade
{{-- Must be inside a Livewire component --}}
<div x-data>
    <button x-on:click="$wire.save()">Save</button>
</div>
```

2. Check Livewire scripts are loaded:

```blade
@livewireScripts
</body>
```

## Performance Issues

### Slow Component Loading

**Solution**:

1. Use lazy loading:

```blade
<livewire:heavy-component lazy />
```

2. Optimize queries in component:

```php
public function render()
{
    return view('livewire.component', [
        // Use pagination instead of loading all
        'items' => Item::paginate(20),
    ]);
}
```

### Too Many Requests

**Symptom**: Multiple requests on single action.

**Solution**:

1. Use debounce for search inputs:

```blade
<input wire:model.live.debounce.300ms="search">
```

2. Batch property updates:

```php
public function updateMultiple(): void
{
    // Updates are batched automatically
    $this->name = 'John';
    $this->email = 'john@example.com';
}
```

## Test Issues

### Livewire Test Helpers Not Working

**Solution**:

1. Ensure test class uses Livewire testing:

```php
use Livewire\Livewire;

class MyComponentTest extends TestCase
{
    public function test_component_renders(): void
    {
        Livewire::test(MyComponent::class)
            ->assertSee('Expected Content');
    }
}
```

2. Check component can be instantiated:

```php
public function test_component_exists(): void
{
    $this->assertTrue(class_exists(MyComponent::class));
}
```

### Assertion Failures

**Error**: `Failed asserting that ... contains ...`

**Solution**:

1. Dump the response to see actual content:

```php
Livewire::test(MyComponent::class)
    ->assertSee('Expected')  // Failing
    ->dump();  // Add this to see actual HTML
```

2. Check component state:

```php
Livewire::test(MyComponent::class)
    ->assertSet('propertyName', 'expected-value');
```

## Cache Issues

### Stale Views

**Solution**:

```bash
php artisan view:clear
php artisan cache:clear
php artisan config:clear
```

### Compiled Class Issues

**Solution**:

```bash
composer dump-autoload
php artisan clear-compiled
```

## Getting Help

If you're still stuck:

1. **Check Livewire Documentation**: [livewire.laravel.com](https://livewire.laravel.com)
2. **Search GitHub Issues**: [github.com/livewire/livewire/issues](https://github.com/livewire/livewire/issues)
3. **Ask on Discord**: [Livewire Discord](https://discord.gg/livewire)

## Next Steps

- [Testing](../05-testing/README.md) - Verify your upgrade
- [Patterns](../04-patterns/README.md) - Common patterns
