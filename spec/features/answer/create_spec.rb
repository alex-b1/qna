require 'rails_helper'

feature 'User can create answers for questions', %q{
  In order to help with problem of question
  As an authenticated user
  I want to be able to create new answer
}do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Create the answer with valid data', js: true do
      fill_in 'Your answer', with: 'Answer text'
      click_on 'Create'
      expect(page).to have_content 'Answer text'
    end

    scenario 'Create the answer with empty data', js: true do
      click_on 'Create'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Unauthenticated user can't create answer", js: true do
    visit question_path(question)
    expect(page).to_not have_content 'Create'
  end
end