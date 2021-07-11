require 'sphinx_helper'

feature 'User can make search', "
  In order to find something
  As a User
  I'd like to be able to make search
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'User make incorrect search for all types', sphinx: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in :body, with: 'tratata'
        click_on 'Find'
      end

      expect(page).to have_content 'No Result'
    end
  end

  scenario 'User make correct search for all types', sphinx: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in :body, with: question.title
        select 'Question', from: :type

        click_on 'Find'
      end
      expect(page).to have_content question.title
    end
  end

  scenario 'User make correct search for question type', sphinx: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in :body, with: question.title
        select 'Question', from: :type

        click_on 'Find'
      end

      expect(page).to have_content question.title
    end
  end
end