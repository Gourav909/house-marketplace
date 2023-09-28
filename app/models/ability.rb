# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all

    unless user.admin?
      cannot [:update, :destroy, :create], Property
    end
  end
end
