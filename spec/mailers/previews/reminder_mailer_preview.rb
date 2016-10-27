# Preview all emails at http://localhost:3000/rails/mailers/reminder_mailer
class ReminderMailerPreview < ActionMailer::Preview
  def reminder
    ReminderMailer.reminder(User.first).deliver_now
  end
end
