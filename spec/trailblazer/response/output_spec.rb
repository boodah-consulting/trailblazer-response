require "spec_helper"

module Trailblazer
  module Response
    RSpec.describe Output do
      let(:model) do
        ActiveModelObject.new()
      end

      let(:contract_model) do
        TestContract.new(
          errors: [
            {
              name: 'something-broken',
              messages: [
                'some error',
                'concatenated with another error',
                'and another one'
              ]
            }
          ]
        )
      end

      let(:responses) do
        [
          Trailblazer::Response::ActiveModel::Model.new(model: model),
          Trailblazer::Response::ContractDefault::Model.new(model: contract_model)
        ]
      end

      describe '.generate' do
        subject(:response_output) { described_class.generate(responses: responses) }

        it 'takes an array' do
          expect {
            described_class.generate(responses: {})
          }.to raise_error(ArgumentError)
        end

        it 'returns a Hash' do
          expect(response_output).to be_a(Hash)
        end
      end

      describe '.errors' do
        subject(:errors) { described_class.errors }

        before :each do
          described_class.generate(responses: responses)
        end

        it 'merges all errors into on flat array' do
          expect(errors).to be_an(Array)
        end

        context 'a single error' do
          subject(:error) { errors.first }

          it 'should be a Hash' do
            expect(error).to be_a(Hash)
          end
        end
      end

      describe '.hashes' do
        subject(:hashes) { described_class.errors }

        before :each do
          described_class.generate(responses: responses)
        end

        it 'is an array' do
          expect(hashes).to be_an(Array)
        end
      end
    end
  end
end
