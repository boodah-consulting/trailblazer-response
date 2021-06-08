module Trailblazer
  module Response
    module ContractDefault
      class Model
        attr_reader :errors

        def initialize(model:)
          self.errors = model.errors
        end

        def errors=(messages)
          @errors = messages.map do |message|
            Trailblazer::Response::ContractDefault::Error.new(
              attribute: message[:name],
              messages: [
                message[:messages].join('; ')
              ]
            )
          end
        end
      end
    end
  end
end
