module Trailblazer
  module Response
    module ActiveModel
      class Model
        attr_reader :name
        attr_reader :errors
        attr_reader :entity

        def initialize(model:)
          self.name = model.class.name
          self.errors = model.errors.messages
          self.entity = model
        end

        def entity=(model)
          @entity = errors.empty? ? model : nil
        end

        def name=(name)
          @name = name.underscore
        end

        def errors=(messages)
          @errors = messages.each_with_object([]) do |(attribute, messages), errors|
            error = Trailblazer::Response::ActiveModel::Error.new(
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
