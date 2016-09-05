require 'rails_helper'

feature 'Log out' do
  let!(:user) { FactoryGirl.create(:user) }
  let(:success_content) { I18n.t('devise.sessions.signed_out') }
  background { login_as(user, scope: :user) }

  scenario 'log out by clicking navbar link' do
    visit('/')
    within('nav') { click_link('Log out') }
    expect(page).to have_content(success_content)
  end
end
