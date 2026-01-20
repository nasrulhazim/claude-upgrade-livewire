# Integration Testing

Testing component interactions and full workflows.

## Testing Component Communication

### Parent-Child Interaction

```php
use Livewire\Livewire;

class ParentChildTest extends TestCase
{
    public function test_child_dispatches_to_parent(): void
    {
        // Test the child component dispatches the event
        Livewire::test(ChildItem::class, ['item' => $this->item])
            ->call('select')
            ->assertDispatched('item-selected');
    }

    public function test_parent_receives_event(): void
    {
        // Test the parent handles the event
        Livewire::test(ParentList::class)
            ->dispatch('item-selected', id: 1)
            ->assertSet('selectedId', 1);
    }
}
```

### Sibling Communication

```php
class SiblingCommunicationTest extends TestCase
{
    public function test_form_notifies_list(): void
    {
        // Test form dispatches event
        Livewire::test(CreateItem::class)
            ->set('name', 'New Item')
            ->call('save')
            ->assertDispatchedTo('item-list', 'item-created');
    }

    public function test_list_handles_creation_event(): void
    {
        // Test list receives and handles event
        Livewire::test(ItemList::class)
            ->dispatch('item-created')
            ->assertSee('Item created');
    }
}
```

## Testing Full Workflows

### CRUD Workflow

```php
class ServiceCrudTest extends TestCase
{
    public function test_full_crud_workflow(): void
    {
        // Create
        Livewire::test(CreateService::class)
            ->set('name', 'Test Service')
            ->set('description', 'A test service')
            ->call('save')
            ->assertHasNoErrors()
            ->assertDispatched('service-created');

        $service = ApiService::where('name', 'Test Service')->first();
        $this->assertNotNull($service);

        // Read/List
        Livewire::test(ServiceIndex::class)
            ->assertSee('Test Service');

        // Update
        Livewire::test(EditService::class, ['service' => $service])
            ->set('name', 'Updated Service')
            ->call('save')
            ->assertHasNoErrors();

        $this->assertEquals('Updated Service', $service->fresh()->name);

        // Delete
        Livewire::test(ServiceIndex::class)
            ->call('delete', $service->id)
            ->assertDispatched('service-deleted');

        $this->assertDatabaseMissing('api_services', ['id' => $service->id]);
    }
}
```

### Form Submission with Validation

```php
class FormWorkflowTest extends TestCase
{
    public function test_form_validation_workflow(): void
    {
        Livewire::test(ContactForm::class)
            // Test empty submission
            ->call('submit')
            ->assertHasErrors(['name', 'email', 'message'])

            // Fill in name only
            ->set('name', 'John')
            ->call('submit')
            ->assertHasNoErrors('name')
            ->assertHasErrors(['email', 'message'])

            // Fill in invalid email
            ->set('email', 'not-an-email')
            ->call('submit')
            ->assertHasErrors(['email' => 'email'])

            // Complete the form
            ->set('email', 'john@example.com')
            ->set('message', 'This is my message')
            ->call('submit')
            ->assertHasNoErrors()
            ->assertDispatched('form-submitted');
    }
}
```

## Testing with Authentication

```php
class AuthenticatedTest extends TestCase
{
    public function test_shows_user_specific_data(): void
    {
        $user = User::factory()->create();
        $userService = ApiService::factory()->create(['user_id' => $user->id]);
        $otherService = ApiService::factory()->create();

        Livewire::actingAs($user)
            ->test(MyServices::class)
            ->assertSee($userService->name)
            ->assertDontSee($otherService->name);
    }

    public function test_admin_sees_all_data(): void
    {
        $admin = User::factory()->admin()->create();

        Livewire::actingAs($admin)
            ->test(ServiceIndex::class)
            ->assertSet('showAll', true);
    }
}
```

## Testing with Database Transactions

```php
use Illuminate\Foundation\Testing\RefreshDatabase;

class DatabaseTransactionTest extends TestCase
{
    use RefreshDatabase;

    public function test_rollback_on_error(): void
    {
        $initialCount = ApiService::count();

        Livewire::test(BulkCreate::class)
            ->set('services', [
                ['name' => 'Service 1'],
                ['name' => ''],  // Invalid - will cause error
            ])
            ->call('createAll')
            ->assertHasErrors();

        // Database should be unchanged due to transaction rollback
        $this->assertEquals($initialCount, ApiService::count());
    }
}
```

## Testing Async Operations

### Testing Polling

```php
public function test_component_polls_for_updates(): void
{
    $job = Job::factory()->processing()->create();

    $component = Livewire::test(JobStatus::class, ['job' => $job]);

    // Simulate job completion
    $job->update(['status' => 'completed']);

    // Trigger poll
    $component->call('checkStatus')
        ->assertSet('status', 'completed');
}
```

## Testing Wire:navigate

```php
public function test_navigation_works(): void
{
    Livewire::test(Dashboard::class)
        ->assertSeeHtml('wire:navigate');
}
```

## Browser Testing with Dusk

For complex JavaScript interactions, use Laravel Dusk:

```php
use Laravel\Dusk\Browser;

class LivewireBrowserTest extends DuskTestCase
{
    public function test_live_search(): void
    {
        $this->browse(function (Browser $browser) {
            $browser->visit('/services')
                ->type('@search-input', 'test')
                ->waitForText('Found 5 results')
                ->assertSee('Test Service');
        });
    }

    public function test_modal_interaction(): void
    {
        $this->browse(function (Browser $browser) {
            $browser->visit('/services')
                ->click('@create-button')
                ->waitFor('@modal')
                ->type('@name-input', 'New Service')
                ->click('@submit-button')
                ->waitForText('Service created')
                ->assertSee('New Service');
        });
    }
}
```

## Test Utilities

### Custom Assertions

```php
// tests/TestCase.php
trait LivewireTestHelpers
{
    protected function assertComponentRendersWithoutErrors(string $component): void
    {
        Livewire::test($component)
            ->assertStatus(200)
            ->assertHasNoErrors();
    }

    protected function assertEventDispatchedWithData(
        string $component,
        string $method,
        string $event,
        array $data
    ): void {
        Livewire::test($component)
            ->call($method)
            ->assertDispatched($event, ...$data);
    }
}
```

### Test Data Factories

```php
// tests/Factories/LivewireTestFactory.php
class LivewireTestFactory
{
    public static function serviceWithRoutes(int $routeCount = 3): ApiService
    {
        $service = ApiService::factory()->create();
        ApiRoute::factory()->count($routeCount)->create([
            'service_id' => $service->id,
        ]);
        return $service;
    }
}
```

## Performance Testing

```php
public function test_component_performance(): void
{
    // Create a lot of data
    ApiService::factory()->count(1000)->create();

    $start = microtime(true);

    Livewire::test(ServiceIndex::class)
        ->assertStatus(200);

    $duration = microtime(true) - $start;

    $this->assertLessThan(1.0, $duration, 'Component should render in under 1 second');
}
```

## Checklist

After running all tests:

- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] No new deprecation warnings
- [ ] Performance is acceptable
- [ ] Browser tests pass (if applicable)

## Next Steps

- [Troubleshooting](../03-migration-guide/04-troubleshooting.md) - Fix issues
- [Patterns](../04-patterns/README.md) - Review patterns
