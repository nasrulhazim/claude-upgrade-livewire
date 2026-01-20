# Event Patterns

Migrating event emission and listening patterns from Livewire 3 to 4.

## Event Dispatching

### Basic Event

**Before (Livewire 3 - deprecated)**:

```php
public function save(): void
{
    // Save logic...

    $this->emit('saved');
}
```

**After (Livewire 4)**:

```php
public function save(): void
{
    // Save logic...

    $this->dispatch('saved');
}
```

### Event with Data

**Before**:

```php
$this->emit('user-created', $user->id, $user->name);
```

**After**:

```php
$this->dispatch('user-created', id: $user->id, name: $user->name);
```

### Event to Specific Component

**Before**:

```php
$this->emitTo('user-list', 'refresh');
$this->emitTo('user-list', 'user-added', $user->id);
```

**After**:

```php
$this->dispatch('refresh')->to('user-list');
$this->dispatch('user-added', id: $user->id)->to('user-list');
```

### Event to Parent

**Before**:

```php
$this->emitUp('item-selected', $item->id);
```

**After**:

```php
$this->dispatch('item-selected', id: $item->id)->up();
```

### Event to Self

**Before**:

```php
$this->emitSelf('refresh');
```

**After**:

```php
$this->dispatch('refresh')->self();
```

## Event Listening

### Static Listeners

**Before (Livewire 3)**:

```php
class UserList extends Component
{
    protected $listeners = [
        'user-created' => 'addUser',
        'user-deleted' => 'removeUser',
        'refresh' => '$refresh',
    ];

    public function addUser($userId): void
    {
        // Handle user created
    }

    public function removeUser($userId): void
    {
        // Handle user deleted
    }
}
```

**After (Livewire 4)**:

```php
use Livewire\Attributes\On;

class UserList extends Component
{
    #[On('user-created')]
    public function addUser($id): void
    {
        // Handle user created
    }

    #[On('user-deleted')]
    public function removeUser($id): void
    {
        // Handle user deleted
    }

    #[On('refresh')]
    public function refreshList(): void
    {
        // Component refreshes
    }
}
```

### Dynamic Listeners

When listeners depend on component state, use `getListeners()`:

**Both versions**:

```php
class ChatRoom extends Component
{
    public int $roomId;

    protected function getListeners(): array
    {
        return [
            "echo:chat.{$this->roomId},MessageSent" => 'handleMessage',
        ];
    }

    public function handleMessage($message): void
    {
        // Handle incoming message
    }
}
```

### Multiple Events on One Method

**Livewire 4**:

```php
use Livewire\Attributes\On;

class Notifications extends Component
{
    #[On('user-created')]
    #[On('user-updated')]
    #[On('user-deleted')]
    public function refreshNotifications(): void
    {
        // Refresh on any user event
    }
}
```

## Browser Events

### Dispatching Browser Events

**Both versions**:

```php
public function save(): void
{
    // Save logic...

    $this->dispatch('notify', message: 'Saved successfully!');
}
```

**Blade (listening)**:

```blade
<div x-on:notify.window="alert($event.detail.message)">
    {{-- Content --}}
</div>
```

### From Blade to Livewire

**Both versions**:

```blade
<button wire:click="$dispatch('item-selected', { id: {{ $item->id }} })">
    Select
</button>
```

## Complete Example

### Before (Livewire 3)

```php
class CreatePost extends Component
{
    public string $title = '';
    public string $content = '';

    protected $listeners = ['draft-loaded' => 'loadDraft'];

    public function loadDraft($draftId): void
    {
        $draft = Draft::find($draftId);
        $this->title = $draft->title;
        $this->content = $draft->content;
    }

    public function save(): void
    {
        $post = Post::create([
            'title' => $this->title,
            'content' => $this->content,
        ]);

        $this->emitTo('post-list', 'post-created', $post->id);
        $this->emit('notify', 'Post created!');
    }
}
```

### After (Livewire 4)

```php
use Livewire\Attributes\On;

class CreatePost extends Component
{
    public string $title = '';
    public string $content = '';

    #[On('draft-loaded')]
    public function loadDraft($id): void
    {
        $draft = Draft::find($id);
        $this->title = $draft->title;
        $this->content = $draft->content;
    }

    public function save(): void
    {
        $post = Post::create([
            'title' => $this->title,
            'content' => $this->content,
        ]);

        $this->dispatch('post-created', id: $post->id)->to('post-list');
        $this->dispatch('notify', message: 'Post created!');
    }
}
```

## Next Steps

- [Validation Patterns](02-validation-patterns.md) - Validation approaches
- [State Management](03-state-management.md) - State patterns
