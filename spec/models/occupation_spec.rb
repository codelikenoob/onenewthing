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
  let(:user) { FactoryGirl.create(:user) }
  let(:thing) { FactoryGirl.create(:thing) }
  let(:occupation) { Occupation.create(user: user, thing: thing, status: "want_to") }

  it { belong_to(:user) }
  it { belong_to(:thing) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:thing_id) }

  it "can change occupations status" do
    expect {
      occupation.change_status("in_progress")
    }.to change(occupation, :status).from("want_to").to("in_progress")
  end

  it " should raise error when change occupation status to undefined status" do
    expect { 
      occupation.change_status("undefined_status") 
    }.to raise_error(ArgumentError, /not a valid status/)
  end
end
