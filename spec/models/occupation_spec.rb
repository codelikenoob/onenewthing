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

require 'rails_helper'

describe Occupation, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:thing) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:thing_id) }
end
