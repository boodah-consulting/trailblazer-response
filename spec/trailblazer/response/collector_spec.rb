require "spec_helper"

class DummyCollector
  include Trailblazer::Response::Collector
end

RSpec.describe Trailblazer::Response::Collector do
  subject(:collector) { DummyCollector }

  let(:result) do
    TestOperation.call(params, context: { current_user: stubbed_user })
  end

  let(:stubbed_user) { TestUser.new }

  let(:params) do
    {
      name: nil,
      email: nil
    }
  end

  let(:mappers) do
    [
      {
        name: 'model',
        klass: Trailblazer::Response::ActiveModel
      }
    ]
  end

  before :each do
    Trailblazer::Response.config do |c|
      c.mappers = mappers
    end
  end

  describe '.collect' do
    it 'calles the response mappers' do
      expect(Trailblazer::Response)
        .to receive(:mappers)
        .and_return(mappers)

      collector.collect(result)
    end

    context 'when there is only a active model response' do
      let(:expected) do
        [
          {
            "name"=>"active_model_object",
            "errors"=>[
              {
                "attribute"=>"name",
                "messages"=>[
                  "can't be blank"
                ]
              },
              {
                "attribute"=>"email",
                "messages"=>[
                  "can't be blank"
                ]
              }
            ],
            "entity"=>nil
          }
        ]
      end

      it 'has the expected response body' do
        expect(collector.collect(result).as_json).to eql(expected)
      end
    end

    context 'when there are more than one type of response type' do
      let(:result) do
        TestOperationWithFailingContract.call(params, context: { current_user: stubbed_user })
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

      let(:expected) do
        [
          {
            "name"=>"active_model_object",
            "errors"=>[
              {
                "attribute"=>"name",
                "messages"=>[
                  "can't be blank"
                ]
              },
              {
                "attribute"=>"email",
                "messages"=>[
                  "can't be blank"
                ]
              }
            ],
            "entity"=>nil
          },
          {
            "errors"=>[
              {
                "attribute"=>"something-broken",
                "messages"=>[
                  "some error; concatenated with another error; and another one"
                ]
              }
            ]
          }
        ]
      end

      it 'has the expected response body' do
        expect(collector.collect(result).as_json).to eql(expected)
      end
    end
  end
end
