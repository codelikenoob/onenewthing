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
  it { have_many(:users).through(:occupation) }
end
