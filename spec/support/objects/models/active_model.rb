class ActiveModelObject < ActiveModelSerializers::Model
  include ActiveModel::Validations

  attributes :name, :email

  validates_presence_of :name
  validates_presence_of :email
end
