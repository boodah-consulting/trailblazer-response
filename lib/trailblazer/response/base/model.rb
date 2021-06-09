module Trailblazer
  module Response
    module Exceptions
      class IncompleteResponseDefinition < StandardError
      end
    end

    module Base
      class Model < Object
        attr_reader :errors

        def initialize(model:)
          if self.respond_to?(:name) && !self.respond_to?(:entity)
            raise Trailblazer::Response::Exceptions::IncompleteResponseDefinition
          end

          self.errors = model.errors.messages
        end

        def entity=(model)
          @entity = errors.empty? ? model : nil
        end

        def name=(name)
          @name = name.underscore
        end

        def errors=(messages)
          @errors = messages.each_with_object([]) do |(attribute, messages), errors|
            error = self.class.module_parent::Error.new(
              attribute: attribute,
              messages: messages
            )

            errors.append(error)
          end
        end
      end
    end
  end
end
