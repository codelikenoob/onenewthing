class AssociateThingWUser
  attr_reader :user, :thing

  def initialize(user, thing)
    @user = user
    if thing.is_a?(String)
      set_thing(thing)
    elsif thing.is_a?(Thing)
      @thing = thing
    else
      raise ArgumentError, 'second argument must be String(title) or Thing(object)'
    end
  end

  def call
    return false if !thing && user.things.include?(thing)
    user.things << thing
    thing
  end

  private

  def set_thing(title)
    @thing = Thing.find_by_title(title)
  end
end
