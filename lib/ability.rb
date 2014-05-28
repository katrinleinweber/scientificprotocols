class Ability
  include CanCan::Ability

  # Defines all abilities of the current user.
  # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  #
  # The abilities added here are supposed to represent generic abilities, NOT controller-specific
  # action names. NOTE: If you pass :manage it will allow every action. Other common actions
  # here are :read, :create, :update and :destroy.
  #
  # CanCan adds the following aliases by default for common controller actions:
  #
  #   alias_action :index, :show, to: :read
  #   alias_action :new, to: :create
  #   alias_action :edit, to: :update
  #
  # More about aliases: http://rdoc.info/github/ryanb/cancan/CanCan/Ability:alias_action
  #
  # NOTE: order is very important in this file.
  #
  # @param [User] user The User object for whom abilities will be defined.
  # @param [Hash] options Extra options.
  # @option [Boolean] is_admin Whether or not to treat the current user as an admin. This allows
  #   API requests to distinguish between standard and admin roles for the same user.
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
  end
  def define_user_abilities(user)
    can :manage, User, id: user.id
  end
  def define_protocol_abilities(user)
    can :read, Protocol
    can :manage, Protocol, protocol_manager: {user_id: user.id}
  end
  def define_protocol_manager_abilities(user)
    can :manage, ProtocolManager, user_id: user.id
  end
end
