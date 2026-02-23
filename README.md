# auto_decorator

Convention-based decorator autoloading for Rails models.

Decorators are plain Ruby modules that get automatically included into your model classes based on file naming convention — no configuration required.

> **Why not Draper?** Draper wraps objects in presenter classes. `auto_decorator` adds methods directly to the model. Less indirection, less boilerplate, same result for most use cases.

## Installation

Add to your Gemfile:

```ruby
gem "auto_decorator"
```

## Usage

### Convention

Place decorator files in `app/decorators/`. The gem discovers them automatically and includes each module into the matching model class:

| File                                                 | Module                             | Included into             |
| ---------------------------------------------------- | ---------------------------------- | ------------------------- |
| `app/decorators/user_decorator.rb`                   | `UserDecorator`                    | `User`                    |
| `app/decorators/organization_decorator.rb`           | `OrganizationDecorator`            | `Organization`            |
| `app/decorators/organizations/employee_decorator.rb` | `Organizations::EmployeeDecorator` | `Organizations::Employee` |

### Example

```ruby
# app/decorators/user_decorator.rb
module UserDecorator
  def full_name
    [first_name, last_name].compact.join(" ")
  end

  def to_s
    full_name.presence || email
  end
end
```

```ruby
# app/decorators/organizations/employee_decorator.rb
module Organizations
  module EmployeeDecorator
    def active?
      status == "active"
    end
  end
end
```

Since the modules are included directly into the model, decorated methods are available anywhere the model is used:

```ruby
user = User.find(1)
user.full_name  # => "Alice Smith"
user.to_s       # => "Alice Smith"
```

### Generator

Scaffold a new decorator with:

```bash
rails g decorator User
# → creates app/decorators/user_decorator.rb

rails g decorator Organizations::Employee
# → creates app/decorators/organizations/employee_decorator.rb
```

Generated file for `User`:

```ruby
# frozen_string_literal: true

module UserDecorator
end
```

Generated file for `Organizations::Employee`:

```ruby
# frozen_string_literal: true

module Organizations
  module EmployeeDecorator
  end
end
```

### Configuration

The gem works with zero configuration. To override defaults:

```ruby
# config/initializers/auto_decorator.rb
AutoDecorator.configure do |config|
  config.decorators_path = "app/decorators"  # relative to Rails.root
  config.decorator_suffix = "Decorator"
end
```

## How it works

On every `config.to_prepare` (triggered on boot and in development on each request):

1. Glob all `*_decorator.rb` files under `decorators_path`
2. Derive the module name from the file path: `organizations/employee_decorator.rb` → `Organizations::EmployeeDecorator`
3. Derive the model name by stripping the suffix: `Organizations::EmployeeDecorator` → `Organizations::Employee`
4. Call `ModelClass.include(DecoratorModule)` — skips if already included

If the model class doesn't exist (e.g. a decorator for a non-existent model), it is silently skipped.

## Compatibility

|       |           |
| ----- | --------- |
| Ruby  | ≥ 3.2     |
| Rails | 7.0 – 8.1 |

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/alec-c4/auto_decorator).

## License

[MIT](LICENSE.txt)
