require "spec_helper"

class TestUser
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :name
  attr_accessor :email

  attr_accessor :role
  attr_accessor :position
end

class ActiveModelObject < ActiveModelSerializers::Model
  include ActiveModel::Validations

  attributes :name, :email

  validates_presence_of :name
  validates_presence_of :email
end

class TestOperation < Trailblazer::Operation
  step :model
  step :validation

  def model(ctx, context:, **params)
    ctx[:model] = ActiveModelObject.new(params)
  end

  def validation(ctx, **)
    ctx[:model].valid?
  end
end

RSpec.describe Trailblazer::Response do
  subject(:response) { described_class }
  let(:stubbed_user) { TestUser.new }

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
          TestOperation.call(params, context: { current_user: stubbed_user })
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
              active_model_object: {
                name: nil,
                email: nil
              },
              errors: {
                name: [ "can't be blank" ],
                email: [ "can't be blank" ]
              }
            }
          )

          expect(response.build(result: result)).to eql expected
        end

        it 'has errors' do
          expect(response.build(result: result)[:errors].count).to eql 2
        end

        describe 'errors' do
          it 'is an Array'

          context 'a single type of error' do
            it 'has an attribute'
            it 'has an array of messages'
          end
        end
      end
    end
    
    context 'when using a custom error message format' do
      it 'can access the correct errors'
      it 'has the expected result format'
    end

    context 'when there are general errors' do
      it 'can access the correct errors'
      it 'has the expected result format'
    end
  end
end
