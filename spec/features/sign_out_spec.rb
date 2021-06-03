require 'rails_helper'

feature 'User can sign out', %q{
  In order to close session
  As an authenticated user
  I'd like to be able to sign out
} do
  given(:user) { create(:user) }
  background { visit new_user_session_path }

  scenario 'Authenticated user can sign out' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
