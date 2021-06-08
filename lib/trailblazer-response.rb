require 'active_support/core_ext/hash/indifferent_access'
require 'active_model'
require 'active_model_serializers'
require 'trailblazer'


module Trailblazer
  module Response
    class << self
      def build(result:)
        response_hash(subject: subject(result: result), result: result)
      end

      def response_hash(subject:, result:)
        HashWithIndifferentAccess.new(
          {
            subject.to_sym => result['model'].as_json,
            errors: errors(result: result)
          }
        )
      end

      def subject(result:)
        result['model'].class.name.underscore
      end

      def errors(result:)
        if result['model'].errors.empty?
          []
        else
          result['model'].errors.messages.to_h
        end
      end
    end
  end
end
