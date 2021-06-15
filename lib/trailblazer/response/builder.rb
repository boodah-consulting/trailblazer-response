require 'trailblazer/response/merger'
require 'trailblazer/response/collector'

module Trailblazer
  module Response
    module Builder
      module ClassMethods
        def build(result:)
          extracted_response = Trailblazer::Response::Collector.run(result)
          response = Trailblazer::Response::Merger.run(extracted_response)

          {
            response[:name] => response[:entity].as_json,
            errors: response[:errors].as_json
          }.with_indifferent_access
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
      end
    end
  end
end
