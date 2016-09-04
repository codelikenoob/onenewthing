# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#

FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "UserName#{n}" }
    sequence(:email) { |n| "samplemail_#{n}@example.com" }

    factory :user_fake do
      name Faker::Name.name
      email Faker::Internet.email
    end
  end
end
