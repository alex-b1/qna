require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete the question
  As an User
  I'd like to be able to delete the question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author)}

  scenario 'Author can delete his question' do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete question'
    expect(page).to_not have_content question.title
  end

  scenario "Not author can't delete question" do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end

  scenario "Unauthenticated user can't delete question" do
    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end
end