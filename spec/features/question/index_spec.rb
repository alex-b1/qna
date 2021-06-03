require 'rails_helper'

feature 'User can view questions list', %q{
  In order to find the right question
  As an user
  I'd like to be able to view all questions
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user)}

  scenario 'View the list of questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content(question.title) }
  end
end