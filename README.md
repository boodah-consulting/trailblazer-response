# Trailblazer::Response

This is an PoC to help better manage responses coming from Trailblazer Operation's. Allowing for more control of our
response, and errors, in a more consistent format.

The idea here is that whenever there's a response from a Trailblazer operation we usually need to do some work with
the operation results.

This usually follows a standardised pattern, although it's easy to split these patterns into fragments that then get
sprinkled throughout the system.

To address this, we can create our own response handler to manage these discrete pieces of functionality, and
encapsulate them inside of coherent response objects, relating to the specific type of response data we want to
manipulate.


The examples below are only for conceptual context, the next piece would be to define this configuration object to
handle multiple response objects.

## Examples

### Configuration of Response Objects
```ruby

  Trailblazer::Response.config do |config|
    config.response_objects = {
      model: ActiveModelResponseObject,
      'contract.default': ActiveRecordResponseObject,
      general_errors: OperationsResponseObject
    }
  end
```

### Execution of response builder

```ruby
  class TestUser
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :name
    attr_accessor :email

    attr_accessor :role
    attr_accessor :position
  end

  class ActiveModelObject < ActiveModelSerializers::Model
    include ActiveModel::Validations

    attributes :name, :email

    validates_presence_of :name
    validates_presence_of :email
  end

  class TestOperation < Trailblazer::Operation
    step :model
    step :validation

    def model(ctx, context:, **params)
      ctx[:model] = ActiveModelObject.new(params)
    end

    def validation(ctx, **)
      ctx[:model].valid?
    end
  end

  user = TestUser.new 
  result = TestOperation.call(params, context: { current_user: user })
  response = Trailblazer::Response.build(result)

  response = {
    user: {
      first_name: 'Joe',
      last_name: 'Bloggs',
      position: 'Boss',
      profile: {
        hobbies: 'Cooking',
        interests: 'Reading'
      }
    }
  }
```

## Contributing to trailblazer-response
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2021 Yomi Colledge. See LICENSE.txt for
further details.
