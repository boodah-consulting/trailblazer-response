require "spec_helper"

class DummyBuilder
  include Trailblazer::Response::Collector
  include Trailblazer::Response::Merger

  include Trailblazer::Response::Builder
end

RSpec.describe Trailblazer::Response::Builder do
  subject(:builder) { DummyBuilder }

  describe '.build' do
    let(:stubbed_user) { TestUser.new }

    let(:params) do
      {
        name: nil,
        email: nil
      }
    end

    let(:result) do
      TestOperation.call(params, context: { current_user: stubbed_user })
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

    it 'calls the collector' do
      expect(builder)
        .to receive(:collect)
        .and_return([])

      builder.build(result: result)
    end

    it 'calls the merger' do
      allow(builder)
        .to receive(:collect)
        .and_return([])

      expect(builder)
        .to receive(:collect)

      builder.build(result: result)
    end

    it 'returns the response' do
      expect(builder.build(result: result)).to eql(
        {
          active_model_object: nil,
          errors: [
            {
              attribute: 'name',
              messages: [
                'can\'t be blank'
              ]
            },
            {
              attribute: 'email',
              messages: [
                'can\'t be blank'
              ]
            }
          ]
        }.with_indifferent_access
      )
    end
  end
end
