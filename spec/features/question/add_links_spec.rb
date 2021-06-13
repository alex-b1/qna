require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:url) { 'https://mail.ru/' }
  given(:gist_url) { 'https://gist.github.com/alex-b1/ba9f1444dffa83bb8061eed5bb8b35d2' }
  given(:yandex_url) { 'https://yandex.ru/' }
  given(:invalid_url) { 'yandex.ru' }

  scenario 'User adds links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'mail'
    fill_in 'Url', with: url

    click_on 'add link'

    within '.nested-fields'  do
      fill_in 'Link name', with: 'Yandex'
      fill_in 'Url', with: yandex_url
    end

    click_on 'Ask'

    expect(page).to have_link 'mail', href: url
    expect(page).to have_link 'Yandex', href: yandex_url
  end

  scenario 'User try add link witn invalid url' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'yandex'
    fill_in 'Url', with: invalid_url

    click_on 'Ask'

    expect(page).to have_content "Links url is invalid"
  end

  scenario 'User add link to gist when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_content 'Столица Италии? Рим Венеция Неаполь Милан'
  end
end