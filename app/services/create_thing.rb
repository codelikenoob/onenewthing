class CreateThing
  attr_reader :params, :user, :associate

  def initialize(params, user=nil, associate=false)
    @params = params
    @user = user
    @associate = associate
  end

  def call
    thing = Thing.new(params)
    if thing.save
      AssociateThingWUser.new(user, thing).call if associate
      thing
    else
      false
    end
  end
end
