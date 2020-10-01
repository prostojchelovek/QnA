class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
    cannot :read, Badge
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    can :read, :all
    can :create, [ Question, Answer, Comment ]
    can :update, [ Question, Answer ], user_id: @user.id
    can :destroy, [ Question, Answer ], user_id: @user.id
    can :destroy, Link, linkable: { user_id: @user.id }
    can :destroy, ActiveStorage::Attachment, record: { user_id: @user.id }
    can :choose_the_best, Answer, question: { user_id: @user.id }
    can %i[vote_up vote_down cancel_vote], [ Question, Answer ] do |resource|
      !@user.author_of?(resource)
    end

    can :subscribe, Question do |question|
      !@user.find_subscription(question)
    end

    can :unsubscribe, Question do |question|
      @user.find_subscription(question)
    end
  end
end
