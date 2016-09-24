class ThingPolicy < ApplicationPolicy
  attr_reader :user, :thing

  def initialize(user, thing)
    @user = user
    @thing = thing
  end


  %w(edit? update? destroy?).each do |m|
    define_method(m) do
      user.things.include?(thing)
    end
  end

end
