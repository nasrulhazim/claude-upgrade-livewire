# Behavior Changes

Changes in how existing features behave in Livewire 4.

## Overview

Livewire 4 maintains consistent behavior with Livewire 3 in almost all cases. The few changes are improvements that shouldn't affect most applications.

## Event Dispatching

### Named Parameters

Event dispatching now uses named parameters for clarity:

**Livewire 3**:

```php
$this->dispatch('user-created', $user->id, $user->name);
```

**Livewire 4 (recommended)**:

```php
$this->dispatch('user-created', id: $user->id, name: $user->name);
```

Both syntaxes work, but named parameters are clearer and less error-prone.

### Event Payload Access

In event listeners, access parameters by name:

```php
#[On('user-created')]
public function handleUserCreated($id, $name): void
{
    // Parameters are passed by name
}
```

## Computed Properties

### Caching Behavior

The `#[Computed]` attribute now provides automatic request-level caching:

```php
use Livewire\Attributes\Computed;

class Dashboard extends Component
{
    #[Computed]
    public function expensiveCalculation(): array
    {
        // Called once per request, then cached
        return $this->performExpensiveQuery();
    }

    public function render()
    {
        // Both calls use cached result
        $data1 = $this->expensiveCalculation;
        $data2 = $this->expensiveCalculation;

        return view('livewire.dashboard');
    }
}
```

### Clearing Computed Cache

To clear a computed property's cache:

```php
unset($this->expensiveCalculation);
```

## Wire Model Behavior

### Default Deferred

`wire:model` without modifiers is deferred by default (same as Livewire 3):

```blade
{{-- Deferred - updates on form submit or action --}}
<input wire:model="name">

{{-- Live - updates on every keystroke --}}
<input wire:model.live="search">

{{-- Blur - updates when field loses focus --}}
<input wire:model.blur="email">
```

### Debounce Syntax

Debounce works with the live modifier:

```blade
{{-- Debounce live updates --}}
<input wire:model.live.debounce.300ms="search">

{{-- Throttle live updates --}}
<input wire:model.live.throttle.500ms="query">
```

## Form Validation

### Automatic Validation Clearing

Validation errors are automatically cleared when a property is updated:

```php
class ContactForm extends Component
{
    #[Validate('required|email')]
    public string $email = '';

    public function updatedEmail(): void
    {
        // Validation error for email is automatically cleared
        // when user starts typing
    }
}
```

### Real-time Validation

For real-time validation, use `validateOnly`:

```php
public function updatedEmail(): void
{
    $this->validateOnly('email');
}
```

## JavaScript Integration

### Alpine.js Integration

The `$wire` object in Alpine.js has improved TypeScript support:

```blade
<div x-data>
    <button x-on:click="$wire.save()">Save</button>
    <button x-on:click="$wire.set('name', 'John')">Set Name</button>
    <span x-text="$wire.name"></span>
</div>
```

### Entangle

`@entangle` works the same but with better performance:

```blade
<div x-data="{ name: @entangle('name') }">
    <input x-model="name">
</div>
```

## File Uploads

### Temporary URL Handling

Temporary file URLs now have improved security:

```php
class FileUpload extends Component
{
    use WithFileUploads;

    public $photo;

    public function updatedPhoto(): void
    {
        $this->validate([
            'photo' => 'image|max:1024',
        ]);
    }
}
```

```blade
@if ($photo)
    {{-- Temporary preview URL --}}
    <img src="{{ $photo->temporaryUrl() }}">
@endif
```

## Error Handling

### Improved Error Messages

Livewire 4 provides clearer error messages:

- Better stack traces pointing to actual component code
- More descriptive validation error messages
- Clearer hydration error explanations

### Debug Mode

In development, errors include more context:

```php
// config/livewire.php
'debug' => env('APP_DEBUG', false),
```

## Routing Changes

### Full-Page Component Routing

Livewire 4 introduces `Route::livewire()` as the preferred method for registering full-page components:

**Livewire 3**:

```php
use App\Livewire\Dashboard;

Route::get('/dashboard', Dashboard::class);
```

**Livewire 4 (recommended)**:

```php
use App\Livewire\Dashboard;

Route::livewire('/dashboard', Dashboard::class);
```

The old `Route::get()` approach still works but `Route::livewire()` is required for:
- Single-file components
- Multi-file components
- Proper routing behavior across all component architectures

### Package Routing with Namespaces

When packages use `Livewire::addNamespace()` for component registration, routes must use the namespaced component name (string) instead of the class reference:

**Wrong (will fail)**:

```php
use Vendor\MyPackage\Livewire\Dashboard;

// This won't work with addNamespace() registration
Route::livewire('/dashboard', Dashboard::class);
```

**Correct**:

```php
// Use the namespaced component name
Route::livewire('/dashboard', 'my-package::dashboard');
Route::livewire('/users', 'my-package::user-index');
```

### Version-Aware Routing for Packages

Packages supporting both Livewire 3 and 4 need conditional routing:

```php
// routes/my-package.php
use Vendor\MyPackage\Livewire\Dashboard;
use Illuminate\Support\Facades\Route;

$useLivewire4Routing = (function () {
    $setting = config('my-package.livewire', 'auto');
    if ($setting === 'v4') {
        return true;
    }
    if ($setting === 'v3') {
        return false;
    }
    // Auto-detect: check if Route::livewire() macro exists
    return Route::hasMacro('livewire');
})();

Route::group(['prefix' => 'my-package'], function () use ($useLivewire4Routing) {
    if ($useLivewire4Routing) {
        // Livewire 4: Use Route::livewire() with namespaced component names
        Route::livewire('/', 'my-package::dashboard')->name('my-package.dashboard');
        Route::livewire('/users', 'my-package::user-index')->name('my-package.users');
    } else {
        // Livewire 3: Use Route::get() with class references
        Route::get('/', Dashboard::class)->name('my-package.dashboard');
        Route::get('/users', UserIndex::class)->name('my-package.users');
    }
});
```

### Route Parameters

Route parameters work the same way in both versions:

```php
// Both versions support route model binding
Route::livewire('/users/{user}', 'my-package::user-show');

// Component receives the parameter via mount()
public function mount(User $user): void
{
    $this->user = $user;
}
```

## Performance

### Optimized Rendering

Component rendering is more efficient:

- Reduced DOM diffing overhead
- Smaller wire requests
- Better memory management

### Lazy Loading

Lazy loading syntax unchanged but with improved performance:

```blade
<livewire:heavy-component lazy />
```

## Next Steps

- [Migration Guide](../03-migration-guide/README.md) - Upgrade your application
- [Patterns](../04-patterns/README.md) - Common migration patterns
