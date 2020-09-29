require 'rails_helper'

feature 'User can subscribe to the question', %q{
  In order to receive notifications to new answers
  As an authenticated user
  I'd like to be able to subscribe to the question
} do

  given(:user) {create(:user)}
  given(:other_user) {create(:user)}
  given(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user' do
    visit question_path(question)

    expect(page).to_not have_link('Subscribe')
  end

  describe 'Authenticated user', js: true do
    before { sign_in(other_user) }

    scenario 'tries to subscribe' do
      visit question_path(question)
      click_on 'Subscribe'

      expect(page).to have_text('Subscribed')
    end

    scenario 'tries to subscribe twice' do
      question.subscribe(other_user)
      visit question_path(question)

      expect(page).to_not have_link('Subscribe')
    end
  end

end
