module Trailblazer
  module Response
    module Merger
      module ClassMethods
        def merge(collection)
          return {} if collection.empty?

          hashes = 
            collection
            .map(&:as_json)

          errors = hashes.map { |h| h['errors']  }.flatten

          hashes = hashes
            .inject(&:merge)

          hashes['errors'] = errors.is_a?(Array) && errors.present? ? errors : []

          HashWithIndifferentAccess.new(
            hashes
          )
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
      end
    end
  end
end
