class EmailReminderWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    ReminderMailer.reminder(user).deliver_now
  rescue ActiveRecord::RecordNotFound => e
    logger.error "Email worker error..."
    logger.error e.message
  end
end
