class Project < ActiveRecord::Base
  belongs_to :user
  attr_accessible :description, :status, :title
end
