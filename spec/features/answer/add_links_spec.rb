require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question, user: user) }
  given(:gist_url) {'https://github.com/nathanvda/cocoon/pull/454'}
  given(:invalid_url) {'dfgsasdads'}

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add link'

    within all('.nested-fields')[1] do
      fill_in 'Link name', with: 'My gist2'
      fill_in 'Url', with: gist_url
    end

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'My gist2', href: gist_url
    end
  end

  scenario 'User adds invalid link when gives an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'My answer'

    fill_in 'Link name', with: 'invalid_url'
    fill_in 'Url', with: invalid_url

    click_on 'Answer'

    expect(page).to have_content 'Links url is an invalid URL'
    expect(page).to_not have_link 'invalid_url', href: invalid_url

  end
end
