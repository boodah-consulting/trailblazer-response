require "spec_helper"

class BasicResponseModel < Trailblazer::Response::Base::Model; end

class ResponseWithModelAndNoEntity < Trailblazer::Response::Base::Model
  attr_reader :name

  def initialize(model:)
    super(model:model)

    self.name = model.class.name
  end
end

class ResponseWithModel < Trailblazer::Response::Base::Model
  attr_reader :name
  attr_reader :entity

  def initialize(model:)
    super(model:model)

    self.name = model.class.name
    self.entity = model
  end
end

class TestErrorObject
  def self.messages
    []
  end
end

RSpec.describe Trailblazer::Response::Base::Model do
  describe '#new' do
    context 'when only the basics are needed' do
      let(:model) { TestContract.new(errors: TestErrorObject) }

      it 'has errors' do
        expect(BasicResponseModel.new(model: model)).to have_attributes(errors: [])
      end

      it 'does not have access to the model name' do
        expect(BasicResponseModel.new(model: model)).not_to respond_to(:name)
      end

      it 'does not have access to the model entity' do
        expect(BasicResponseModel.new(model: model)).not_to respond_to(:entity)
      end
    end

    context 'when we need to store a model object' do
      let(:model) { TestContract.new(errors: TestErrorObject) }

      context 'and the class is not defined correctly' do
        it 'throws an exception if name and entity attributes are not set' do
          expect {
            ResponseWithModelAndNoEntity.new(model: model)
          }.to raise_error(Trailblazer::Response::Exceptions::IncompleteResponseModel)
        end
      end

      context 'describing the instantiated object' do
        subject(:response_model) { ResponseWithModel.new(model: model) }

        it 'must have a name' do
          expect(response_model.name).to eql('test_contract')
        end

        it 'must have a entity' do
          expect(response_model.entity).to be_a(TestContract)
        end
      end
    end
  end
end
