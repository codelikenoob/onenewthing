require 'rails_helper'
require_relative '../../support/user/log_in_form'

feature 'Log in with login/password' do
  let!(:user) { FactoryGirl.create(:user) }
  let(:log_in_form) { LogInForm.new }
  let(:success_content) { I18n.t('devise.sessions.signed_in') }

  %w(name email).each do |login_word|
    scenario "log in with the #{login_word}" do
      log_in_form.visit_page_direct
                .fill_in_fields(login_word, user)
                .submit
      expect(page).to have_content(success_content)
    end
  end

  scenario 'log in with invalid data' do
    log_in_form.visit_page_direct
              .fill_in_fields('email', user, true)
              .submit
    expect(page).not_to have_content(success_content)
  end
end
