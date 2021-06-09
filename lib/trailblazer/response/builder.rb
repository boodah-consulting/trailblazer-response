require 'trailblazer/response/merger'
require 'trailblazer/response/collector'

module Trailblazer
  module Response
    include Trailblazer::Response::Collector
    include Trailblazer::Response::Merger

    module Builder
      module ClassMethods
        def build(result:)
          extracted_response = collect(result)
          response = merge(extracted_response)

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

