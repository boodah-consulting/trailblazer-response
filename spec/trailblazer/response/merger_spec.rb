require "spec_helper"

RSpec.describe Trailblazer::Response::Merger do
  subject(:merger) { described_class }

  let(:model) do
    ActiveModelObject.new()
  end

  let(:collection) do
    [
      Trailblazer::Response::ActiveModel::Model.new(model: model)
    ]
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

  describe '.run' do
    before :each do
      model.valid?
    end

    context 'when there is only a active model response' do
      let(:expected) do
        {
          name: "active_model_object",
          errors: [
            {
              attribute: "name",
              messages: [
                "can't be blank"
              ]
            },
            {
              attribute: "email",
              messages: [
                "can't be blank"
              ]
            }
          ],
          entity: nil
        }.with_indifferent_access
      end

      it 'has the expected response body' do
        expect(merger.run(collection).as_json).to eql(expected)
      end
    end

    context 'when there are more than one type of response type' do
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

      let(:collection) do
        [
          Trailblazer::Response::ActiveModel::Model.new(model: model),
          Trailblazer::Response::ContractDefault::Model.new(model: contract_model)
        ]
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
            },
            {
              "attribute"=>"something-broken",
              "messages"=>[
                "some error; concatenated with another error; and another one"
              ]
            }
          ],
          "entity"=>nil
        }.with_indifferent_access
      end

      before :each do
        Trailblazer::Response.config do |c|
          c.mappers = mappers
        end

        model.valid?
      end

      it 'has the expected response body' do
        expect(merger.run(collection).as_json).to eql(expected)
      end
    end
  end
end
