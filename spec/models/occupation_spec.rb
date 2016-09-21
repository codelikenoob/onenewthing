require 'rails_helper'

descrive Occupation, type: :model do
  it { belong_to(:user) }
  it { belong_to(:thing) }
end
