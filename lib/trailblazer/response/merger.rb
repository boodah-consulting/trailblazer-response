module Trailblazer
  module Response
    module Merger
      module ClassMethods
        def merge(collection)
          HashWithIndifferentAccess.new(
            collection
            .map(&:as_json)
            .inject(&:merge)
          )
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
      end
    end
  end
end
