module Trailblazer
  module Response
    module Output
      class << self
        attr_reader :responses

        def generate(responses: [])
          raise ArgumentError unless responses.is_a?(Array)

          self.responses = responses

          hash = self.hashes
            .inject(&:merge)

          hash[:errors] = self.errors.is_a?(Array) && self.errors.present? ? self.errors : []

          hash
        end

        def errors
          responses.map do |response|
            response.errors.map(&:as_json)
          end.flatten
        end

        def hashes
          responses
            .map(&:as_json)
            .map(&:with_indifferent_access)
        end

        attr_writer :responses
      end
    end
  end
end
