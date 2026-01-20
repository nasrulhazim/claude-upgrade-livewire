# Unit Testing

Testing individual Livewire components.

## Basic Component Testing

Works identically in both versions:

```php
use Livewire\Livewire;
use App\Livewire\Counter;

class CounterTest extends TestCase
{
    public function test_component_renders(): void
    {
        Livewire::test(Counter::class)
            ->assertSee('Count: 0');
    }

    public function test_can_increment(): void
    {
        Livewire::test(Counter::class)
            ->call('increment')
            ->assertSet('count', 1);
    }
}
```

## Testing Properties

### Initial State

```php
public function test_initial_state(): void
{
    Livewire::test(UserForm::class)
        ->assertSet('name', '')
        ->assertSet('email', '')
        ->assertSet('active', true);
}
```

### Setting Properties

```php
public function test_can_set_properties(): void
{
    Livewire::test(UserForm::class)
        ->set('name', 'John Doe')
        ->set('email', 'john@example.com')
        ->assertSet('name', 'John Doe')
        ->assertSet('email', 'john@example.com');
}
```

### With Mount Parameters

```php
public function test_mount_with_model(): void
{
    $user = User::factory()->create(['name' => 'Jane']);

    Livewire::test(EditUser::class, ['user' => $user])
        ->assertSet('name', 'Jane');
}
```

## Testing Actions

### Calling Methods

```php
public function test_can_save(): void
{
    Livewire::test(CreatePost::class)
        ->set('title', 'My Post')
        ->set('content', 'Content here')
        ->call('save')
        ->assertHasNoErrors();

    $this->assertDatabaseHas('posts', ['title' => 'My Post']);
}
```

### Testing Return Values

```php
public function test_method_redirects(): void
{
    Livewire::test(CreatePost::class)
        ->set('title', 'My Post')
        ->set('content', 'Content here')
        ->call('save')
        ->assertRedirect('/posts');
}
```

## Testing Validation

### Validation Errors

```php
public function test_name_required(): void
{
    Livewire::test(UserForm::class)
        ->set('name', '')
        ->call('save')
        ->assertHasErrors(['name' => 'required']);
}

public function test_email_must_be_valid(): void
{
    Livewire::test(UserForm::class)
        ->set('email', 'not-an-email')
        ->call('save')
        ->assertHasErrors(['email' => 'email']);
}
```

### No Validation Errors

```php
public function test_valid_data_has_no_errors(): void
{
    Livewire::test(UserForm::class)
        ->set('name', 'John Doe')
        ->set('email', 'john@example.com')
        ->call('save')
        ->assertHasNoErrors();
}
```

## Testing Events

### Dispatched Events

```php
public function test_dispatches_event_on_save(): void
{
    Livewire::test(CreatePost::class)
        ->set('title', 'My Post')
        ->set('content', 'Content')
        ->call('save')
        ->assertDispatched('post-created');
}
```

### Event with Data

```php
public function test_event_contains_data(): void
{
    $post = Post::factory()->create();

    Livewire::test(EditPost::class, ['post' => $post])
        ->call('save')
        ->assertDispatched('post-updated', id: $post->id);
}
```

### Event to Component

```php
public function test_dispatches_to_specific_component(): void
{
    Livewire::test(CreateItem::class)
        ->call('save')
        ->assertDispatchedTo('item-list', 'item-created');
}
```

## Testing URL State

### URL Parameters

```php
public function test_search_in_url(): void
{
    Livewire::withQueryParams(['search' => 'test'])
        ->test(ProductIndex::class)
        ->assertSet('search', 'test');
}

public function test_updates_url_on_search(): void
{
    Livewire::test(ProductIndex::class)
        ->set('search', 'laptop')
        ->assertSet('search', 'laptop');
}
```

## Testing Computed Properties

```php
public function test_computed_property(): void
{
    Livewire::test(Dashboard::class)
        ->assertSet('stats', function ($stats) {
            return isset($stats['users']) && isset($stats['orders']);
        });
}
```

## Testing Pagination

```php
public function test_pagination_resets_on_search(): void
{
    // Create test data
    User::factory()->count(30)->create();

    Livewire::test(UserIndex::class)
        ->set('page', 2)
        ->assertSet('page', 2)
        ->set('search', 'test')
        ->assertSet('page', 1);  // Page resets
}
```

## Testing File Uploads

```php
use Illuminate\Http\UploadedFile;
use Livewire\Livewire;

public function test_can_upload_file(): void
{
    $file = UploadedFile::fake()->image('avatar.png');

    Livewire::test(ProfilePhoto::class)
        ->set('photo', $file)
        ->call('save')
        ->assertHasNoErrors();
}
```

## Complete Test Example

```php
use Livewire\Livewire;
use App\Livewire\ServiceIndex;
use App\Models\ApiService;

class ServiceIndexTest extends TestCase
{
    public function test_component_renders(): void
    {
        Livewire::test(ServiceIndex::class)
            ->assertStatus(200);
    }

    public function test_displays_services(): void
    {
        $service = ApiService::factory()->create(['name' => 'Test API']);

        Livewire::test(ServiceIndex::class)
            ->assertSee('Test API');
    }

    public function test_can_search_services(): void
    {
        ApiService::factory()->create(['name' => 'Payment API']);
        ApiService::factory()->create(['name' => 'User API']);

        Livewire::test(ServiceIndex::class)
            ->set('search', 'Payment')
            ->assertSee('Payment API')
            ->assertDontSee('User API');
    }

    public function test_can_filter_by_status(): void
    {
        ApiService::factory()->create(['name' => 'Active', 'status' => 'approved']);
        ApiService::factory()->create(['name' => 'Draft', 'status' => 'draft']);

        Livewire::test(ServiceIndex::class)
            ->set('status', 'approved')
            ->assertSee('Active')
            ->assertDontSee('Draft');
    }

    public function test_persists_search_in_url(): void
    {
        Livewire::withQueryParams(['search' => 'api'])
            ->test(ServiceIndex::class)
            ->assertSet('search', 'api');
    }

    public function test_resets_page_on_search_change(): void
    {
        ApiService::factory()->count(30)->create();

        Livewire::test(ServiceIndex::class)
            ->set('page', 2)
            ->set('search', 'test')
            ->assertSet('page', 1);
    }

    public function test_can_sort_services(): void
    {
        Livewire::test(ServiceIndex::class)
            ->assertSet('sortBy', 'name')
            ->assertSet('sortDirection', 'asc')
            ->call('sortBy', 'name')
            ->assertSet('sortDirection', 'desc');
    }
}
```

## Next Steps

- [Integration Testing](02-integration-testing.md) - Test interactions
- [Troubleshooting](../03-migration-guide/04-troubleshooting.md) - Fix issues
