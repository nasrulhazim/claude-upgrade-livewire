# Deprecations

Features that are deprecated in Livewire 4 but still work. These should be updated when convenient but won't break your application.

## Event Emission Methods

### `$this->emit()` (Deprecated)

The `emit()` method is deprecated in favor of `dispatch()`.

**Before (Livewire 3)**:

```php
class CreatePost extends Component
{
    public function save(): void
    {
        // Create post...

        $this->emit('post-created');
        $this->emit('post-created', $post->id);
    }
}
```

**After (Livewire 4)**:

```php
class CreatePost extends Component
{
    public function save(): void
    {
        // Create post...

        $this->dispatch('post-created');
        $this->dispatch('post-created', id: $post->id);
    }
}
```

### `$this->emitTo()` (Deprecated)

**Before (Livewire 3)**:

```php
$this->emitTo('post-list', 'refresh');
```

**After (Livewire 4)**:

```php
$this->dispatch('refresh')->to('post-list');
```

### `$this->emitUp()` (Deprecated)

**Before (Livewire 3)**:

```php
$this->emitUp('item-selected', $item->id);
```

**After (Livewire 4)**:

```php
$this->dispatch('item-selected', id: $item->id)->up();
```

### `$this->emitSelf()` (Deprecated)

**Before (Livewire 3)**:

```php
$this->emitSelf('refresh');
```

**After (Livewire 4)**:

```php
$this->dispatch('refresh')->self();
```

## Event Listeners

### `$listeners` Property (Deprecated)

The `$listeners` property is deprecated in favor of the `#[On]` attribute.

**Before (Livewire 3)**:

```php
class PostList extends Component
{
    protected $listeners = [
        'post-created' => 'refreshList',
        'post-deleted' => '$refresh',
    ];

    public function refreshList(): void
    {
        // Refresh logic
    }
}
```

**After (Livewire 4)**:

```php
use Livewire\Attributes\On;

class PostList extends Component
{
    #[On('post-created')]
    public function refreshList(): void
    {
        // Refresh logic
    }

    #[On('post-deleted')]
    public function refresh(): void
    {
        // Component will refresh
    }
}
```

### `getListeners()` Method (Still Supported)

The `getListeners()` method still works and is useful for dynamic listeners:

```php
class DynamicComponent extends Component
{
    public string $channel;

    protected function getListeners(): array
    {
        return [
            "echo:channels.{$this->channel},MessageSent" => 'handleMessage',
        ];
    }
}
```

## Blade Directives

### `@this` (Still Works)

The `@this` directive still works but using Alpine's `$wire` is preferred:

**Before**:

```blade
<button onclick="@this.call('save')">Save</button>
```

**Preferred**:

```blade
<button x-on:click="$wire.save()">Save</button>
```

## Migration Priority

| Deprecation | Priority | Notes |
|-------------|----------|-------|
| `emit()` → `dispatch()` | Medium | Update during normal maintenance |
| `$listeners` → `#[On]` | Low | Update when touching the file |
| `@this` → `$wire` | Low | Optional, both work |

## Automated Detection

Find deprecated patterns in your codebase:

```bash
# Find emit usage
grep -r "->emit(" app/ --include="*.php"
grep -r "->emitTo(" app/ --include="*.php"
grep -r "->emitUp(" app/ --include="*.php"
grep -r "->emitSelf(" app/ --include="*.php"

# Find $listeners property
grep -r "protected \$listeners" app/ --include="*.php"

# Find @this in Blade
grep -r "@this" resources/views --include="*.blade.php"
```

## Next Steps

- [Removed Features](02-removed-features.md) - Features no longer available
- [Patterns](../04-patterns/README.md) - Migration examples
