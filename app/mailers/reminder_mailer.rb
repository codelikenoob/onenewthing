class ReminderMailer < ApplicationMailer
  helper MailerHelper

  def reminder(user)
    @user = user
    @occupations = @user.occupations.includes(:thing).where(status: :in_progress)
    mail to: @user.email, subject: 'Your things'
  end

  def monthly_reminder(user)
    @user = user
    @occupations = @user.occupations.includes(:thing).where(status: :in_progress)
    mail to: @user.email, subject: 'Did you complite your things?'
  end
end
