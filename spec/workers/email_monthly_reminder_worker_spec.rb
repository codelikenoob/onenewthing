require 'rails_helper'

describe EmailMonthlyReminderWorker do
  let(:user) { create(:user) }
  before { Sidekiq::Worker.clear_all }

  it 'push job to the queue' do
    expect {
      EmailMonthlyReminderWorker.perform_in(30.days, user.id)
    }.to change(EmailMonthlyReminderWorker.jobs, :size).by(1)
  end
end
