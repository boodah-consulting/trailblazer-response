class TestUser
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :name
  attr_accessor :email

  attr_accessor :role
  attr_accessor :position
end
