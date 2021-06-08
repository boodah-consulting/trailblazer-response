module Trailblazer
  module Response
    module Configuration
      class << self
        attr_accessor :mappers

        def configure
          yield self
        end

        alias_method :config, :configure
      end
    end
  end
end
