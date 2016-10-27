class ReminderMailer < ApplicationMailer
  def reminder(user)
    @user = user
    @occupations = @user.occupations.includes(:thing).where(status: :in_progress)
    mail to: @user.email,
      subject: 'Ваши занятия'
  end
end
