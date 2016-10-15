# == Schema Information
#
# Table name: occupations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  thing_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer          not null, default: 0
#

FactoryGirl.define do
  factory :occupation do
    user
    thing
    status :in_progress
  end
end
