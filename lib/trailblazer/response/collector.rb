module Trailblazer
  module Response
    module Collector
      module ClassMethods
        def collect(result)
          Trailblazer::Response.mappers.map do |mapper|
            model = result[mapper[:name]]
            klass = "#{mapper[:klass]}::Model".constantize

            klass.new(model: model)
          end
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
      end
    end
  end
end
