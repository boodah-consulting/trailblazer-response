module Trailblazer
  module Response
    module Merger
      class << self
        def run(responses)
          return {} if responses.empty?

          Trailblazer::Response::Output.generate(responses: responses)
        end
      end
    end
  end
end
