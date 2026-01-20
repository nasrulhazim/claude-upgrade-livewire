# State Management

URL state, computed properties, and component state patterns.

## URL State Management

### Using #[Url] Attribute

Works identically in both versions:

```php
use Livewire\Attributes\Url;

class ProductIndex extends Component
{
    #[Url]
    public string $search = '';

    #[Url]
    public string $category = '';

    #[Url]
    public string $sort = 'name';

    #[Url]
    public int $page = 1;
}
```

### Using $queryString Property

Works identically in both versions:

```php
class ProductIndex extends Component
{
    public string $search = '';
    public string $category = '';
    public int $page = 1;

    protected $queryString = [
        'search' => ['except' => ''],
        'category' => ['except' => ''],
        'page' => ['except' => 1],
    ];
}
```

### URL Aliases

Works identically in both versions:

```php
use Livewire\Attributes\Url;

class SearchResults extends Component
{
    #[Url(as: 'q')]
    public string $search = '';

    #[Url(as: 'p')]
    public int $page = 1;
}
```

### URL History

Works identically in both versions:

```php
use Livewire\Attributes\Url;

class FilterableList extends Component
{
    #[Url(history: true)]
    public string $filter = '';
}
```

## Computed Properties

### Using #[Computed] Attribute (Recommended)

**Livewire 4**:

```php
use Livewire\Attributes\Computed;

class Dashboard extends Component
{
    #[Computed]
    public function stats(): array
    {
        return [
            'users' => User::count(),
            'orders' => Order::count(),
            'revenue' => Order::sum('total'),
        ];
    }

    #[Computed]
    public function recentOrders(): Collection
    {
        return Order::latest()->take(10)->get();
    }

    public function render()
    {
        return view('livewire.dashboard');
    }
}
```

**Access in Blade**:

```blade
<div>
    <p>Users: {{ $this->stats['users'] }}</p>
    <p>Revenue: ${{ $this->stats['revenue'] }}</p>

    @foreach($this->recentOrders as $order)
        <div>{{ $order->id }}</div>
    @endforeach
</div>
```

### Using get*Property Methods

Works in both versions (Livewire 3 style):

```php
class ProductList extends Component
{
    public function getFilteredProductsProperty(): Collection
    {
        return Product::where('active', true)->get();
    }
}
```

### Clearing Computed Cache

**Livewire 4**:

```php
class Dashboard extends Component
{
    #[Computed]
    public function stats(): array
    {
        return ['count' => User::count()];
    }

    public function refreshStats(): void
    {
        // Clear the computed cache
        unset($this->stats);
    }
}
```

## Component State

### Reset State

Works identically in both versions:

```php
class CreatePost extends Component
{
    public string $title = '';
    public string $content = '';
    public array $tags = [];

    public function save(): void
    {
        Post::create([
            'title' => $this->title,
            'content' => $this->content,
            'tags' => $this->tags,
        ]);

        $this->reset();  // Resets all public properties
    }

    public function cancel(): void
    {
        $this->reset(['title', 'content']);  // Reset specific properties
    }
}
```

### Fill State

Works identically in both versions:

```php
class EditPost extends Component
{
    public string $title = '';
    public string $content = '';

    public function mount(Post $post): void
    {
        $this->fill([
            'title' => $post->title,
            'content' => $post->content,
        ]);
    }
}
```

### Only/Except

Works identically in both versions:

```php
class UserForm extends Component
{
    public string $name = '';
    public string $email = '';
    public string $password = '';

    public function getData(): array
    {
        return $this->only(['name', 'email']);
    }

    public function getPublicData(): array
    {
        return $this->except(['password']);
    }
}
```

## Pagination State

Works identically in both versions:

```php
use Livewire\WithPagination;
use Livewire\Attributes\Url;

class UserIndex extends Component
{
    use WithPagination;

    #[Url]
    public string $search = '';

    public function updatedSearch(): void
    {
        $this->resetPage();
    }

    public function render()
    {
        return view('livewire.user-index', [
            'users' => User::where('name', 'like', "%{$this->search}%")
                ->paginate(10),
        ]);
    }
}
```

## Complete Example

```php
use Livewire\Attributes\Computed;
use Livewire\Attributes\Url;
use Livewire\WithPagination;

class ServiceIndex extends Component
{
    use WithPagination;

    #[Url]
    public string $search = '';

    #[Url]
    public string $status = '';

    #[Url]
    public string $type = '';

    #[Url]
    public string $sortBy = 'name';

    #[Url]
    public string $sortDirection = 'asc';

    #[Computed]
    public function statuses(): array
    {
        return ApiStatus::cases();
    }

    #[Computed]
    public function types(): array
    {
        return ApiType::cases();
    }

    public function updatedSearch(): void
    {
        $this->resetPage();
    }

    public function updatedStatus(): void
    {
        $this->resetPage();
    }

    public function updatedType(): void
    {
        $this->resetPage();
    }

    public function sortBy(string $column): void
    {
        if ($this->sortBy === $column) {
            $this->sortDirection = $this->sortDirection === 'asc' ? 'desc' : 'asc';
        } else {
            $this->sortBy = $column;
            $this->sortDirection = 'asc';
        }
    }

    public function render()
    {
        $query = ApiService::query();

        if ($this->search) {
            $query->where('name', 'like', "%{$this->search}%");
        }

        if ($this->status) {
            $query->where('status', $this->status);
        }

        if ($this->type) {
            $query->where('type', $this->type);
        }

        $query->orderBy($this->sortBy, $this->sortDirection);

        return view('livewire.service-index', [
            'services' => $query->paginate(15),
        ]);
    }
}
```

## Next Steps

- [Testing](../05-testing/README.md) - Test your components
- [Troubleshooting](../03-migration-guide/04-troubleshooting.md) - Common issues
