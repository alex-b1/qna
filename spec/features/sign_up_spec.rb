require 'rails_helper'

feature 'User can sign up', %q{
  In order to start session
  As an unauthenticated user
  I'd like to be able to sign up
} do
  given(:user) { create(:user) }
  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Email', with: '111@mail.ru'
    fill_in 'Password', with: '111111'
    fill_in 'Password confirmation', with: '111111'
    click_on 'Sign up'

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
  end

  scenario 'Unregistered user tries to sign up with registrated email' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '111111'
    fill_in 'Password confirmation', with: '111111'
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Unregistered user tries to sign up with unvalid password' do
    fill_in 'Email', with: '111@mail.ru'
    fill_in 'Password', with: '123'
    fill_in 'Password confirmation', with: '123'
    click_on 'Sign up'

    expect(page).to have_content 'Password is too short (minimum is 6 characters)'
  end

  scenario 'Unregistered user tries to sign up with different password and passport confirmation' do
    fill_in 'Email', with: '111@mail.ru'
    fill_in 'Password', with: '123123'
    fill_in 'Password confirmation', with: '111111'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end