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
end
