# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :me, User, user: user

    can [:create, :make_comment], [Question, Answer]
    can [:update, :destroy], [Question, Answer], user_id: user.id

    can :destroy, Link, linkable: { user_id: user.id }
    can :mark_as_best, Answer, question: { user_id: user.id }

    can :destroy, ActiveStorage::Attachment do |file|
      user.author?(file.record)
    end

    can [:vote_up, :vote_down, :cancel_vote], [Question, Answer] do |resource|
      resource.user_id != user.id
    end
  end
end
