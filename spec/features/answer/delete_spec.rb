require 'rails_helper'

feature 'User can delete answer', %q{
  As an authenticated user
  I'd like to be able to delete my answer
  And only I can delete my answer
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given!(:answer) {create(:answer, question: question, user: user)}

  given(:other_user) {create(:user)}
  given!(:other_user_question) {create(:question, user: other_user)}
  given!(:other_user_answer) {create(:answer, question: other_user_question, user: other_user)}

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'trying to delete their answer' do
      visit question_path(question)
      click_on 'Delete answer'
      expect(page).to_not have_content answer.body
    end

    scenario "trying to delete someone else's answer" do
      visit question_path(other_user_question)

      expect(page).to_not have_content 'Delete answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario "is trying to delete someone answer" do
      visit question_path(question)
      expect(page).to_not have_content 'Delete answer'
    end
  end
end
