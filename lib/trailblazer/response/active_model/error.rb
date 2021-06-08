require 'active_support/core_ext/hash/indifferent_access'

module Trailblazer
  module Response
    module ActiveModel
      class Error < BasicObject
        attr_accessor :attribute
        attr_accessor :messages

        def initialize(attribute:, messages:)
          self.attribute = attribute
          self.messages = messages
        end

        def as_json(options={})
            {
              attribute: attribute,
              messages: messages
            }.as_json(options)
        end
      end
    end
  end
end
