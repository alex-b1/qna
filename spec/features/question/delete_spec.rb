require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete the question
  As an User
  I'd like to be able to delete the question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:question_with_attachment) { create(:question, :with_attachment, user: author) }

  scenario 'Author can delete his question' do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete question'
    expect(page).to_not have_content question.title
  end

  scenario 'Author can delete attachments', js: true do
    sign_in(author)
    visit question_path(question_with_attachment)
    expect(page).to have_link question_with_attachment.filename
    click_on 'Delete file'
    expect(page).to_not have_link question_with_attachment.filename
  end

  scenario 'Not an author try to delete attached files', js: true do
    sign_in(user)
    visit question_path(question_with_attachment)

    expect(page).to have_link question_with_attachment.filename
    expect(page).to_not have_link 'Delete file'
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