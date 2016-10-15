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

require 'rails_helper'

describe Thing, type: :model do
  it { should have_many(:users).through(:occupations) }
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }
end
