require 'rails_helper'
require_relative '../../support/user/registration_form'

feature 'Registration with email' do
  let(:registration_form) { RegistrationForm.new }
  let(:success_content_regexp) do
    Regexp.new([I18n.t('devise.registrations.signed_up'),
                I18n.t('devise.registrations.signed_up_but_inactive'),
                # I18n.t('devise.registrations.signed_up_but_locked'),
                I18n.t('devise.registrations.signed_up_but_unconfirmed')]
                .join('|'))
  end

  scenario 'registration with valid data' do
    registration_form.visit_page_direct
                     .fill_in_with
                     .submit
    expect(page).to have_content(success_content_regexp)
  end

  scenario 'registration with invalid data' do
    registration_form.visit_page_direct
                     .fill_in_with(name: '')
                     .submit
    expect(page).not_to have_content(success_content_regexp)
  end
end
