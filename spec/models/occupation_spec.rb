# == Schema Information
#
# Table name: occupations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  thing_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Occupation, type: :model do
  it { belong_to(:user) }
  it { belong_to(:thing) }
end
