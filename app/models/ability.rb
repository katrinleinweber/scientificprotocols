class Ability
  include CanCan::Ability
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
    can :read, User
    can [:read, :discussion], Protocol
  end
  def define_user_abilities(user)
    can :read, User
    can :manage, User, id: user.id
    cannot :create, User, id: user.id
  end
  def define_protocol_abilities(user)
    can [:read, :create, :star, :unstar, :fork, :discussion, :create_comment, :delete_comment], Protocol
    can :manage, Protocol, users: {id: user.id}
  end
  def define_protocol_manager_abilities(user)
    can :manage, ProtocolManager, user_id: user.id
    cannot :create, ProtocolManager, user_id: user.id
  end
end
