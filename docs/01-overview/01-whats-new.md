# What's New in Livewire 4

Livewire 4 brings performance improvements, better developer experience, and enhanced features while maintaining strong backward compatibility with Livewire 3.

## Key Improvements

### Performance Enhancements

- Optimized component rendering
- Reduced JavaScript bundle size
- Improved hydration performance
- Better memory management

### Developer Experience

- Enhanced error messages with clearer stack traces
- Improved debugging tools
- Better IDE support and autocompletion
- Streamlined configuration

### TypeScript Support

- Improved TypeScript definitions
- Better type inference for component properties
- Enhanced IDE integration

## Maintained Features

Livewire 4 maintains full support for these Livewire 3 features:

### PHP Attributes

```php
use Livewire\Attributes\Layout;
use Livewire\Attributes\Url;
use Livewire\Attributes\Validate;
use Livewire\Attributes\Computed;
use Livewire\Attributes\On;

#[Layout('layouts.app')]
class MyComponent extends Component
{
    #[Url]
    public string $search = '';

    #[Validate('required|min:3')]
    public string $name = '';

    #[Computed]
    public function filteredItems(): array
    {
        return $this->items->filter(...);
    }

    #[On('item-created')]
    public function handleItemCreated(): void
    {
        // Handle event
    }
}
```

### Blade Directives

All Livewire 3 blade directives work unchanged:

```blade
{{-- Model binding --}}
<input wire:model="name">
<input wire:model.live="search">
<input wire:model.blur="email">
<input wire:model.live.debounce.300ms="query">

{{-- Actions --}}
<button wire:click="save">Save</button>
<button wire:click.prevent="submit">Submit</button>

{{-- Navigation --}}
<a wire:navigate href="/dashboard">Dashboard</a>

{{-- Confirmation --}}
<button wire:click="delete" wire:confirm="Are you sure?">Delete</button>

{{-- Loading states --}}
<div wire:loading>Loading...</div>
<div wire:loading.remove>Content</div>
```

### Traits

All standard traits continue to work:

```php
use Livewire\WithPagination;
use Livewire\WithFileUploads;

class MyComponent extends Component
{
    use WithPagination;
    use WithFileUploads;
}
```

### Lifecycle Methods

All lifecycle hooks remain unchanged:

```php
class MyComponent extends Component
{
    public function mount($id): void
    {
        // Called when component initializes
    }

    public function hydrate(): void
    {
        // Called on every request
    }

    public function updating($property, $value): void
    {
        // Called before property updates
    }

    public function updated($property, $value): void
    {
        // Called after property updates
    }

    public function updatedPropertyName($value): void
    {
        // Called when specific property updates
    }
}
```

## New Optional Features

### `#[Computed]` Attribute

The `#[Computed]` attribute provides automatic caching for expensive computations:

```php
use Livewire\Attributes\Computed;

class Dashboard extends Component
{
    #[Computed]
    public function stats(): array
    {
        // This is automatically cached for the request
        return [
            'users' => User::count(),
            'orders' => Order::count(),
        ];
    }
}
```

### `#[On]` Attribute

The `#[On]` attribute replaces `getListeners()` for cleaner event handling:

```php
use Livewire\Attributes\On;

class ItemList extends Component
{
    #[On('item-created')]
    public function refreshList(): void
    {
        // Handle the event
    }

    #[On('echo:orders,OrderShipped')]
    public function handleOrderShipped($event): void
    {
        // Handle Echo event
    }
}
```

## Next Steps

- [Compatibility](02-compatibility.md) - Check version requirements
- [Upgrade Assessment](03-upgrade-assessment.md) - Assess your codebase
- [Breaking Changes](../02-breaking-changes/README.md) - Review what changed
