require 'rails_helper'

feature 'User can comment a question', %q{
  In order to get more information about question
  As an authenticated user
  I'd like to be able to comments
} do

  given(:user) { create :user }
  given!(:question) { create :question, user: user }

  describe 'Not authenticated user' do
    scenario 'Can not comment' do
      visit question_path(question)

      expect(page).to_not have_selector '.new-comment'
    end
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can sent comment' do
      within '.question_comments' do
        fill_in 'Body', with: 'Test comment'
        click_on 'Add comment'
      end

      expect(page).to have_content 'Test comment'
    end
  end

  describe 'Multiple sessions', js: true do
    scenario 'comments appears on another users page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question_comments' do
          fill_in 'Body', with: 'Test comment'
          click_on 'Add comment'
        end

        expect(page).to have_content 'Test comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test comment'
      end
    end
  end
end