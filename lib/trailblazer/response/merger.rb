module Trailblazer
  module Response
    module Merger
      module ClassMethods
        def merge(responses)
          return {} if responses.empty?

          Trailblazer::Response::Output.generate(responses: responses)
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
      end
    end
  end
end
