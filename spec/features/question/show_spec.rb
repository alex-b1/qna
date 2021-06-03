require 'rails_helper'

feature "User cann see a question and it's answers" , %q{
  In order to help with question
  As an a User
  I'd like to be able to view a question and answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_pair(:answer, question: question, user: user)}

  describe 'User' do
    background {visit question_path(question)}

    scenario "View question's attributes" do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'View the answers to a question' do
      answers.each { |answer| expect(page).to have_content answer.body }
    end
  end
end