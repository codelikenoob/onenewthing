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
  let(:user) { create(:user) }
  let(:thing) { create(:thing) }
  let(:occupation) { Occupation.create(user: user, thing: thing, status: "want_to") }

  it { should belong_to(:user) }
  it { should belong_to(:thing) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:thing_id) }

  it 'can change occupations status' do
    expect {
      occupation.in_progress!
    }.to change(occupation, :status).from("want_to").to("in_progress")
  end
end
