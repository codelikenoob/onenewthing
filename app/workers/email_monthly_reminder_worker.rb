class EmailMonthlyReminderWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    ReminderMailer.monthly_reminder(user).deliver_now
  rescue
    logger.error "Email worker error..."
    logger.error e.message
  end
end
