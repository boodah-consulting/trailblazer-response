class TestOperationWithFailingContract < Trailblazer::Operation
  step :model
  step :process
  step :validation

  def model(ctx, context:, **params)
    ctx[:model] = ActiveModelObject.new(params)
  end

  def validation(ctx, **)
    ctx[:model].valid?
  end

  def process(ctx, **)
    contract = TestContract.new(
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
    ctx['contract.default'] = contract
  end
end
