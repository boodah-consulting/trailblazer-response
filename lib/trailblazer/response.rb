require 'forwardable'
require 'trailblazer/response/builder'
require 'trailblazer/response/active_model'

module Trailblazer
  module Response
    include Trailblazer::Response::Builder

    class << self
      extend Forwardable

      def_delegators :'Trailblazer::Response::Configuration',
        :configure, :config

      def_delegators :'Trailblazer::Response::Configuration',
        :mappers
    end
  end
end
