require "pry"
module Trailblazer
  module Response
    module ActiveModel
      class Model < Trailblazer::Response::Base::Model
        attr_reader :name
        attr_reader :entity

        
        def initialize(model:)
          super(model:model)

          self.name = model.class.name
          self.entity = model
        end
      end
    end
  end
end
