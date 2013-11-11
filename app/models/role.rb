class Role < ActiveRecord::Base
  attr_accessible :description, :name
  has_and_belongs_to_many :permissions
  has_and_belongs_to_many :users
  belongs_to :role
  delegate :permissions, :to => :role

end
