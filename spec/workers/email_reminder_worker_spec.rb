require 'rails_helper'

describe EmailReminderWorker do
  let(:user) { create(:user) }
  before { Sidekiq::Worker.clear_all }
  
  it 'push job to the queue' do
    expect {
      EmailReminderWorker.perform_in(5.days, user.id)
    }.to change(EmailReminderWorker.jobs, :size).by(1)
  end
end
