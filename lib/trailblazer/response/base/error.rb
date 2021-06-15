module Trailblazer
  module Response
    module Base
      class Error < Object
        attr_accessor :attribute
        attr_accessor :messages

        def initialize(attribute:, messages:)
          self.attribute = attribute
          self.messages = messages
        end

        def as_json(options={})
          {
            attribute: attribute,
            messages: messages
          }
            .as_json(options)
            .with_indifferent_access
        end
      end
    end
  end
end
