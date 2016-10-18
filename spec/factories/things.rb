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
FactoryGirl.define do
  factory :thing do
    transient { user nil }
    sequence(:title) { |n| "title_#{n}" }
    description 'test_description_string'

    after(:create) do |thing, evaluator|
      evaluator.user.things << thing if evaluator.user
    end
  end
end
