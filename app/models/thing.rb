# == Schema Information
#
# Table name: things
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Thing < ApplicationRecord
  has_many :occupations
  has_many :users, through: :occupations

  validates :title, presence: true, uniqueness: true

  def create(user = nil)
    if self.save
      user.associate(self) if user
      self
    else
      false
    end
  end

  def self.create_or_associate(params, user)
    title = params[:title]
    associated = user.associate(title)
    return associated if associated
    created = Thing.new(params).create(user)
    return created if created
    false
  end
end
