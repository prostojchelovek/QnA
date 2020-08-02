require 'rails_helper'

feature 'User can create answer to the question', %q{
  In order to help a community solve the problems
  As an authenticated user
  Being on the question page
  I'd like to be able to answer the questions
} do

  given(:user) {create(:user)}
  given(:question) {create(:question, user: user)}

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'create an answer' do
      fill_in 'Body', with: 'text text'
      click_on 'Answer'

      expect(page).to have_content 'The answer was sent.'
      expect(page).to have_content 'text text'
    end

    scenario 'create a question with errors' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end
end
