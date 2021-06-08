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
