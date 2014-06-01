# Custom rspec matcher for CanCan.
# Originally from: https://github.com/ryanb/cancan/wiki/Testing-Abilities
#
# Usage:
#   should have_ability(:create, for: Post.new)
#   should have_ability([:create, :read], for: Post.new)
#   should have_ability({create: true, read: false, update: false, destroy: true}, for: Post.new)
RSpec::Matchers.define :have_ability do |ability_hash, options = {}|
  match do |user|
    ability = Ability.new(user)
    target = options[:for]
    @ability_result = {}
    ability_hash = {ability_hash => true} if ability_hash.is_a? Symbol
    ability_hash = ability_hash.inject({}){|_, i| _.merge({i=>true}) } if ability_hash.is_a? Array
    ability_hash.each do |action, true_or_false|
      @ability_result[action] = ability.can?(action, target)
    end
    ability_hash == @ability_result
  end

  failure_message_for_should do |user|
    ability_hash,options = expected
    ability_hash = {ability_hash => true} if ability_hash.is_a? Symbol
    ability_hash = ability_hash.inject({}){|_, i| _.merge({i=>true}) } if ability_hash.is_a? Array
    target = options[:for]
    message = (
    "expected User:#{user} to have ability:#{ability_hash} for " +
      "#{target}, but actual result is #{@ability_result}"
    )
  end

  # To clean up output of RSpec Documentation format.
  description do
    target = expected.last[:for]
    target = if target.class == Symbol
      target.to_s.capitalize
    elsif target.class == Class || target.class == Module
      target.to_s.capitalize
    else
      target.class.name
    end
    authorized_abilities   = ability_hash.select{|key, val| val == true}
    authorized_string      = "authorized to #{authorized_abilities.keys.join(", ")}"
    unauthorized_abilities = ability_hash.select{|key, val| val == false}
    unauthorized_string    = "unauthorized to #{unauthorized_abilities.keys.join(", ")}"
    "be #{authorized_string unless authorized_abilities.empty?}" \
    "#{' and ' unless authorized_abilities.empty? || unauthorized_abilities.empty?}" \
    "#{unauthorized_string unless unauthorized_abilities.empty?}" \
    " for #{target}"
  end
end