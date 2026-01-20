# Validation Patterns

Validation approaches in Livewire 4.

## Overview

Livewire 4 maintains full compatibility with Livewire 3 validation. All patterns continue to work.

## Property Rules Array

Works identically in both versions:

```php
class ContactForm extends Component
{
    public string $name = '';
    public string $email = '';
    public string $message = '';

    protected array $rules = [
        'name' => 'required|min:3|max:100',
        'email' => 'required|email',
        'message' => 'required|min:10',
    ];

    protected array $messages = [
        'name.required' => 'Please enter your name.',
        'name.min' => 'Name must be at least 3 characters.',
        'email.required' => 'Please enter your email.',
        'email.email' => 'Please enter a valid email address.',
    ];

    public function submit(): void
    {
        $this->validate();

        // Process form...
    }
}
```

## Validate Attribute

Works identically in both versions:

```php
use Livewire\Attributes\Validate;

class CreateUser extends Component
{
    #[Validate('required|min:3')]
    public string $name = '';

    #[Validate('required|email|unique:users')]
    public string $email = '';

    #[Validate('required|min:8|confirmed')]
    public string $password = '';

    #[Validate('required')]
    public string $password_confirmation = '';

    public function create(): void
    {
        $this->validate();

        User::create([
            'name' => $this->name,
            'email' => $this->email,
            'password' => Hash::make($this->password),
        ]);
    }
}
```

## Real-Time Validation

Works identically in both versions:

```php
class RegistrationForm extends Component
{
    #[Validate('required|email|unique:users')]
    public string $email = '';

    public function updatedEmail(): void
    {
        $this->validateOnly('email');
    }
}
```

## Conditional Validation

Works identically in both versions:

```php
class OrderForm extends Component
{
    public string $type = 'standard';
    public string $rush_reason = '';

    protected function rules(): array
    {
        $rules = [
            'type' => 'required|in:standard,rush',
        ];

        if ($this->type === 'rush') {
            $rules['rush_reason'] = 'required|min:10';
        }

        return $rules;
    }
}
```

## Array Validation

Works identically in both versions:

```php
class RouteManager extends Component
{
    public array $paths = [''];
    public array $methods = ['GET'];

    protected array $rules = [
        'paths' => 'required|array|min:1',
        'paths.*' => 'required|string|starts_with:/',
        'methods' => 'required|array|min:1',
        'methods.*' => 'required|in:GET,POST,PUT,PATCH,DELETE',
    ];
}
```

## Custom Validation Rules

Works identically in both versions:

```php
use Illuminate\Validation\Rule;

class UpdateProfile extends Component
{
    public int $userId;
    public string $email = '';

    protected function rules(): array
    {
        return [
            'email' => [
                'required',
                'email',
                Rule::unique('users')->ignore($this->userId),
            ],
        ];
    }
}
```

## Form Objects

Works identically in both versions:

```php
use Livewire\Form;
use Livewire\Attributes\Validate;

class PostForm extends Form
{
    #[Validate('required|min:3')]
    public string $title = '';

    #[Validate('required|min:10')]
    public string $content = '';

    #[Validate('nullable|array')]
    public array $tags = [];
}

class CreatePost extends Component
{
    public PostForm $form;

    public function save(): void
    {
        $this->form->validate();

        Post::create($this->form->all());
    }
}
```

## Validation in Blade

Works identically in both versions:

```blade
<form wire:submit="save">
    <div>
        <label>Name</label>
        <input wire:model="name" type="text">
        @error('name')
            <span class="text-red-500">{{ $message }}</span>
        @enderror
    </div>

    <div>
        <label>Email</label>
        <input wire:model="email" type="email">
        @error('email')
            <span class="text-red-500">{{ $message }}</span>
        @enderror
    </div>

    <button type="submit">Submit</button>
</form>
```

## Reset Validation

Works identically in both versions:

```php
class MyForm extends Component
{
    public function cancel(): void
    {
        $this->reset();
        $this->resetValidation();
    }

    public function clearEmailError(): void
    {
        $this->resetValidation('email');
    }
}
```

## Adding Errors Manually

Works identically in both versions:

```php
class PaymentForm extends Component
{
    public function processPayment(): void
    {
        try {
            // Process payment...
        } catch (PaymentException $e) {
            $this->addError('payment', 'Payment failed: ' . $e->getMessage());
        }
    }
}
```

## Complete Example

```php
use Livewire\Attributes\Validate;
use Livewire\Attributes\On;

class ConsumerForm extends Component
{
    public ?ApiConsumer $consumer = null;

    #[Validate('required_without:custom_id|nullable|string|max:255')]
    public string $username = '';

    #[Validate('required_without:username|nullable|string|max:255')]
    public string $custom_id = '';

    #[Validate('nullable|array')]
    public array $tags = [];

    public function mount(?ApiConsumer $consumer = null): void
    {
        if ($consumer) {
            $this->consumer = $consumer;
            $this->username = $consumer->username ?? '';
            $this->custom_id = $consumer->custom_id ?? '';
            $this->tags = $consumer->tags ?? [];
        }
    }

    public function save(): void
    {
        $this->validate();

        if ($this->consumer) {
            $this->consumer->update($this->getFormData());
            $this->dispatch('consumer-updated');
        } else {
            ApiConsumer::create($this->getFormData());
            $this->dispatch('consumer-created');
        }
    }

    private function getFormData(): array
    {
        return [
            'username' => $this->username ?: null,
            'custom_id' => $this->custom_id ?: null,
            'tags' => $this->tags,
        ];
    }
}
```

## Next Steps

- [State Management](03-state-management.md) - State patterns
- [Testing](../05-testing/README.md) - Test your validation
