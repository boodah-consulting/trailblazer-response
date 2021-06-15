require "spec_helper"

module Foo
  class Model < Trailblazer::Response::Base::Model
    attr_reader :name
    attr_reader :entity
  end
end

module Bar
  module Baz
    class Model < Foo::Model
    end
  end
end

module Bar
  module Baz
    class Error < Trailblazer::Response::Base::Error
    end
  end
end

RSpec.describe Trailblazer::Response, type: :integration do
  subject(:response) { Bar::Baz::Model.new(model: test_model) }
  let(:test_model) { ActiveModelObject.new }

  context 'inheriting from an existing model class' do
    before :each do
      test_model.valid?
    end

    it 'can access the expected errors' do
      expected = [
        {
          attribute: 'name',
          messages: [
            "can't be blank"
          ]
        },
        {
          attribute: 'email',
          messages: [
            "can't be blank"
          ]
        }
      ].map(&:with_indifferent_access)
      expect(response.errors.as_json.map(&:with_indifferent_access)).to eql(expected)
    end
  end
end
