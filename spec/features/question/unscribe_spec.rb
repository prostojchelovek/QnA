require 'rails_helper'

feature 'User can unsubscribe to the question', %q{
  In order to remove notifications to new answers
  As an authenticated user
  I'd like to be able to unsubscribe to the question
} do

  given(:user) {create(:user)}
  given(:other_user) {create(:user)}
  given(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user' do
    visit question_path(question)

    expect(page).to_not have_link('Unsubscribe')
  end

  describe 'Authenticated user', js: true do
    before { sign_in(other_user) }

    scenario 'tries to unsubscribe' do
      question.subscribe(other_user)
      visit question_path(question)
      click_on 'Unsubscribe'

      expect(page).to have_text('Unsubscribed')
    end

    scenario 'tries to unsubscribe twice' do
      question.unsubscribe(other_user)

      visit question_path(question)
      expect(page).to_not have_link('Unsubscribe')
    end
  end

end
