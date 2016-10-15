# == Schema Information
#
# Table name: occupations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  thing_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer
#

class Occupation < ApplicationRecord
  enum status: [:in_progress, :finished, :dropped, :want_to]

  belongs_to :user
  belongs_to :thing

  validates :thing_id, presence: true
  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: :thing_id }
end
