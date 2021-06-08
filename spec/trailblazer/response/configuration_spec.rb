require "spec_helper"

module Trailblazer
  module Response
    RSpec.describe Configuration do
      before :each do
        described_class.config do |c|
          c.mappers = mappers
        end
      end

      let(:mappers) do
        [
          {
            name: 'active_model',
            klass: Trailblazer::Response::ActiveModel
          },
          {
            name: 'contract.default',
            klass: Trailblazer::Response::ContractDefault
          }
        ]
      end

      it 'has a list of mappers to use' do
        expect(described_class.mappers).to eql(mappers)
      end
    end
  end
end
