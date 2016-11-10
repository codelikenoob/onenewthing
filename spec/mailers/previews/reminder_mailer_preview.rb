# Preview all emails at http://localhost:3000/rails/mailers/reminder_mailer
class ReminderMailerPreview < ActionMailer::Preview
  def reminder
    ReminderMailer.reminder(User.first)
  end

  def monthly_reminder
    ReminderMailer.monthly_reminder(User.first)
  end
end
