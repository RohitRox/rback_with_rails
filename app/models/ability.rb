class Ability
	include CanCan::Ability

  def initialize(user)
    if user.roles.include?("admin")
      can :manage, :all
    else
      can :update, line
    end
  end
end