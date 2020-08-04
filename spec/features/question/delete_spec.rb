require 'rails_helper'

feature 'User can delete question', %q{
  As an authenticated user
  I'd like to be able to delete my question
  And only I can delete my question
} do
  
  given(:user) {create(:user)}
  given(:other_user) {create(:user)}
  given(:question) {create(:question, user: user)}

  describe 'Authenticated user' do
    scenario 'is trying to delete their question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete question'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario "is trying to delete someone else's question" do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_content 'Delete question'
    end
  end

  scenario "Authenticated user is trying to delete someone question" do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to_not have_content 'Delete question'
  end
end
