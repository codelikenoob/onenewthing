class OccupationPolicy < ApplicationPolicy
  attr_reader :user, :occupation

  def initialize(user, occupation)
    @user = user
    @occupation = occupation
  end

  def change_status?
    occupation.user == user
  end
end
