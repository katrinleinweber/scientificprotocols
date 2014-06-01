class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/bryanrite/cancancan/wiki/Defining-Abilities
    def initialize(user, options = {})
      # Define abilities for unauthenticated users.
      if user.blank?
        define_guest_abilities user
        return
      end
      # For these, assume the user is authenticated.
      define_user_abilities user
      define_protocol_abilities user
      define_protocol_manager_abilities user
    end
    def define_guest_abilities(user)
      can :read, Protocol
      can :read, ProtocolManager
    end
    def define_user_abilities(user)
      can :manage, User, id: user.id
    end
    def define_protocol_abilities(user)
      can [:read, :create], Protocol
      can :manage, Protocol, users: {id: user.id}
    end
    def define_protocol_manager_abilities(user)
      can [:read, :create], ProtocolManager
      can :manage, ProtocolManager, user_id: user.id
    end
  end
end
