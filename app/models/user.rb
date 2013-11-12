class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  has_many :projects
  has_and_belongs_to_many :roles

  after_create :assign_role


  def is_admin?
    self.roles.map(&:name).include?("admin")
  end

  def assign_role(role = nil)
    role ||=  Role.find_by_name("new_user")
    self.roles << role
    self.save
  end

  def get_projects(params)
    return Project.page(params[:page]) if self.is_admin?
    return self.projects.page(params[:page]) if self.is_a_project_manager?
    []
  end

  def method_missing(method_id, *args)
    if match = matches_dynamic_role_check?(method_id)
      !(tokenize_roles(match.captures.first) & roles.map(&:name)).empty?
    else
      super
    end
  end


  def can_view_project?(project)

  end

  def can_update_project?(project)
    permissions = []
    self.roles.each do |role|
      permissions << role.permissions.select(:name).map(&:name)
    end
    permissions.flatten.include?("can_update_project?")
  end

  def can_delete_project?(project)

  end

  private

  def matches_dynamic_role_check?(method_id)
    /^is_an?_([a-zA-Z]\w*)\?$/.match(method_id.to_s)
  end

  def tokenize_roles(string_to_split)
    string_to_split.split(/_or_/)
  end

end
