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

    scenario 'asks a answer with attached file', js: true do
      fill_in 'Your answer', with: 'Answer text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario "Unauthenticated user can't create answer", js: true do
    visit question_path(question)
    expect(page).to_not have_content 'Create'
  end
end