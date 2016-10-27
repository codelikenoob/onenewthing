require "rails_helper"

RSpec.describe ReminderMailer, type: :mailer do
  let!(:user) { create(:user) }
  let!(:thing) { create(:thing, title: "My thing", user: user) }
  let(:email) { ReminderMailer.reminder(user).deliver_now }

  it 'sends reminder email to user' do
    expect(email.to).to include(user.email)
  end

  it 'has related things in body message' do
    expect(email.body.to_s).to have_content(thing.title)
  end

  it 'has link to thing in body message' do
    expect(email.body).to have_link('Изменить статус', href: thing_url(thing))
  end
end
