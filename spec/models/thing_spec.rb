require 'rails_helper'

descrive Thing, type: :model do
  it { have_many(:users).through(:occupation) }
end
