require 'rails_helper'

feature 'User can choose the best answer for his question', %q{
  In order to help another user from a community
  As an authencated User
  I'd like to be able to choose answer that helped me and mark it as best answer
}  do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:answers) { create_list(:answer, 3, question: question, user: author) }

  describe 'Author of question', js: true do
    background do
      sign_in author
      visit question_path(answer.question)
    end

    scenario 'mark as best answer' do
      within "#answer-#{answer.id}" do
        expect(page).not_to have_selector '.best'
        click_on 'Mark as best'
        expect(page).to have_selector '.best'
      end
    end

    scenario 'set new answer as best' do
      within "#answer-#{answers[1].id}" do
        click_on 'Mark as best'
        expect(page).to have_selector '.best'
      end

      within "#answer-#{answers[0].id}" do
        click_on 'Mark as best'
        expect(page).to_not have_selector '.best'
      end

      answers[1, answers.size].each do |answer|
        within "#answer-#{answer.id}" do
          expect(page).to have_selector '.best-no'
        end
      end
    end
  end

  scenario "User tries to mark best answer of other user's question", js: true do
    sign_in user
    visit question_path(answer.question)

    expect(page).to_not have_link 'Mark as best'
  end

  scenario "Unauthenticated user tries to mark best answer" do
    visit question_path(answer.question)

    expect(page).to_not have_link 'Mark as best'
  end
end