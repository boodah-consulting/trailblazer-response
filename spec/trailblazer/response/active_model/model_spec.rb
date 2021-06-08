require "spec_helper"

class TestModel < ActiveModelSerializers::Model
  include ActiveModel::Validations

  attributes :name, :email

  validates_presence_of :name
  validates_presence_of :email
end

module Trailblazer
  module Response
    module ActiveModel
      RSpec.describe Model do
        subject(:response) { described_class.new(model: model) }

        let(:model) { TestModel.new }

        it 'requires an ActiveModel model' do
          expect {
            described_class.new()
          }.to raise_error(ArgumentError)
        end

        it 'returns the name of the class, underscored' do
          expect(response.name).to eql('test_model')
        end

        describe "#errors" do
          context 'when there are no errors' do
            it 'has an empty array' do
              expect(response.errors).to be_empty
            end
          end

          context "when there are errors present" do
            before :each do
              model.valid?
            end

            it 'returns a list of errors' do
              expect(response.errors).not_to be_empty
            end

            context 'a single error' do
              subject(:a_single_error) { response.errors.first }

              it 'has an attribute' do
                expect(a_single_error.attribute).to eql(:name)
              end

              it 'has a message' do
                expect(a_single_error.messages).to eql([
                  'can\'t be blank'
                ])
              end
            end
          end
        end

        describe '#entity' do
          context 'when there are no errors' do
            let(:model) { TestModel.new(name: 'Joe Bloggs', email: 'y@me.com') }

            it 'returns the model object' do
              expect(response.entity.as_json).to eql(model.as_json)
            end
          end

          context 'when there are errors' do
            let(:model) { TestModel.new }

            before :each do
              model.valid?
            end

            it 'returns the model object' do
              expect(response.entity).to be_nil
            end
          end
        end
      end
    end
  end
end
