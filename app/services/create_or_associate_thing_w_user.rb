class CreateOrAssociateThingWUser
  attr_reader :user, :params, :thing_title

  def initialize(user, params)
    @user = user
    @params = params
    @thing_title = @params[:title].strip.downcase
  end

  def call
    # TODO: refactor
    associated = AssociateThingWUser.new(user, thing_title).call
    return associated if associated
    created = CreateThing.new(params, user, true).call
    return created if created
    return false
  end

end
