require "spec_helper"

RSpec.describe Trailblazer::Response do
  subject(:response) { described_class }
  let(:stubbed_user) { TestUser.new }

  let(:mappers) do
    [
      {
        name: 'model',
        klass: Trailblazer::Response::ActiveModel
      }
    ]
  end

  before :each do
    described_class.config do |c|
      c.mappers = mappers
    end
  end

  describe '.build' do
    let(:params) do
      {
        name: nil,
        email: nil
      }
    end

    it 'requires a result as an argument' do
      expect{
        result = TestOperation.call(params, context: { current_user: stubbed_user })

        response.build(result: result)
      }.to_not raise_error
    end

    context 'when using an active model' do
      context 'when the operation is successful' do
        let(:result) do
          TestOperation.call(params, context: { current_user: stubbed_user })
        end

        let(:params) do
          {
            name: 'Joe Bloggs',
            email: 'me@example.com'
          }
        end

        it 'returns the expected hash result' do
          expected = HashWithIndifferentAccess.new(
            {
              active_model_object: {
                name: 'Joe Bloggs',
                email: 'me@example.com'
              },
              errors: []
            }
          )
          allow(result)
            .to receive(:'success?')
            .and_return true

          expect(response.build(result: result)).to eql expected
        end
      end

      context 'when the operation is not successful' do
        let(:result) do
          TestOperationWithFailingContract.call(params, context: { current_user: stubbed_user })
        end

        let(:params) do
          {
            name: nil,
            email: nil
          }
        end

        it 'returns an expected response' do
          expected = HashWithIndifferentAccess.new(
            {
              active_model_object: nil,
              errors: [
                {
                  attribute: 'name',
                  messages: [ "can't be blank" ]
                },
                {
                  attribute: 'email',
                  messages: [ "can't be blank" ]
                }
              ]
            }
          )

          expect(response.build(result: result)).to eql expected
        end

        it 'has errors' do
          expect(response.build(result: result)[:errors].count).to eql 2
        end

        describe 'errors' do
          subject(:response) { described_class.build(result: result) }

          it 'is an Array' do
            expect(response[:errors]).to be_an Array
          end

          context 'a single type of error' do
            subject(:errors) { response[:errors] }

            it 'has an attribute'
            it 'has an array of messages'
          end
        end
      end
    end

    context 'when using a custom error message format' do
      subject(:response) { described_class.build(result: result) }

      let(:result) do
        TestOperationWithFailingContract.call(params, context: { current_user: stubbed_user })
      end

      before :each do
        result['model'].valid?

        described_class.config do |c|
          c.mappers = mappers
        end
      end

      let(:mappers) do
        [
          {
            name: 'model',
            klass: Trailblazer::Response::ActiveModel
          },
          {
            name: 'contract.default',
            klass: Trailblazer::Response::ContractDefault
          }
        ]
      end

      let(:default_contract_errors) do 
        {
          attribute: 'something-broken',
          messages: [
            'some error; concatenated with another error; and another one'
          ]
        }
      end

      it 'can access the correct errors' do
        expect(response[:errors]).to include(default_contract_errors)
      end

      it 'has the expected result format' do
        expect(response).to eql(
          HashWithIndifferentAccess.new(
            {
              active_model_object: nil,
              errors: [
                {
                  attribute: 'name',
                  messages: [ "can't be blank" ]
                },
                {
                  attribute: 'email',
                  messages: [ "can't be blank" ]
                },
                {
                  attribute: 'something-broken',
                  messages: [
                    'some error; concatenated with another error; and another one'
                  ]
                }
              ]

            }
          )
        )
      end
    end

    context 'when there are general errors' do
      it 'can access the correct errors'
      it 'has the expected result format'
    end
  end
end
