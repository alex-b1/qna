require 'rails_helper'

feature 'User can change the question', %q{
  In order to change the question from a community
  As an authenticated user
  I'd like to be able to edit the question
} do
  given(:user) {create(:user)}

  describe 'Authenticated user' do
    given(:author) { create(:user) }
    given!(:question) { create(:question, :with_attachment, user: author) }

    background do
      sign_in(author)
      visit questions_path
    end

    scenario 'Edit a question', js: true do
      click_on 'Edit'

      within '.question' do
        fill_in 'title', with: 'Edit question'
        fill_in 'body', with: 'text text text'
        click_on 'Save'
      end

      expect(page).to have_content 'Edit question'

      question.reload

      visit question_path(question)

      expect(page).to have_content 'Edit question'
      expect(page).to have_content 'text text text'
    end

    scenario 'Edit a question with errors', js: true do
      click_on 'Edit'
      within '.question' do
        fill_in 'title', with: ''
        fill_in 'body', with: ''
      end

      click_on 'Save'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'Edit a question with attached file', js: true do
      click_on 'Edit'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Save'

      visit question_path(question)

      expect(page).to have_content 'rails_helper.rb'
    end
  end

  scenario "Authenticated user tries to edit other user's question", js: true do
    sign_in user
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  scenario 'Unauthenticated user can not edit answer' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end
end