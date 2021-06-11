require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to delete non-actual answer
  As an user
  I want to be able to delete my answer
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author) }
  given(:answer_with_attachment) { create(:answer, :with_attachment, question: question, user: author) }

  scenario 'Authenticated user destroys own answer', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)
    click_on 'Delete answer'
    expect(current_path).to eq question_path answer.question
    expect(page).to_not have_content answer.body
  end

  scenario 'Author can delete attachments', js: true do
    sign_in(answer_with_attachment.user)
    visit question_path(answer_with_attachment.question)
    expect(page).to have_link answer_with_attachment.filename
    click_on 'Delete file'
    expect(page).to_not have_link answer_with_attachment.filename
  end

  scenario 'Not an author try to delete attached files', js: true do
    sign_in(user)
    visit question_path(answer_with_attachment.question)

    expect(page).to have_link answer_with_attachment.filename
    expect(page).to_not have_link 'Delete file'
  end

  scenario "Authenticated user can't destroy other user's answer" do
    sign_in(user)
    visit question_path(answer.question)
    expect(page).to_not have_link 'Delete answer'
  end

  scenario "Unauthenticated user can't destroy any answer" do
    visit question_path(answer.question)
    expect(page).to_not have_link 'Delete answer'
  end
end