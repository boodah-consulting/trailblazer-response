module Trailblazer
  module Response
    module Collector
      class << self
        def run(result)
          Trailblazer::Response.mappers.map do |mapper|
            model = result[mapper[:name]]
            klass = "#{mapper[:klass]}::Model".constantize

            klass.new(model: model)
          end
        end
      end
    end
  end
end
