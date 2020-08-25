require 'rails_helper'

feature 'User can delete link', %q{
  As an authenticated user
  I'd like to be able to delete link of my answer
  And no one except me can delete my link
} do

  given(:user) {create(:user)}
  given(:other_user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given!(:other_question) {create(:question, user: other_user)}
  given!(:answer) {create :answer, question: question, user: user}
  given!(:link) { create :link, name: 'link_name', url: 'https://www.youtube.com/watch?v=5MJ55_bu_jM', linkable: answer }

  describe 'Author', js: true do
    scenario "tying to delete link" do
      sign_in(user)
      visit question_path(question)
      within '.answers' do
        click_on 'Delete link'
        expect(page).to_not have_content 'link_name'
      end
    end
  end

  describe 'Not author', js: true do
    scenario "tying to delete someone else's link" do
      sign_in(user)
      visit question_path(other_question)

      expect(page).to_not have_link 'Delete link'
    end
  end

  describe 'Unauthenticate user', js: true do
    scenario "tying to delete link" do
      visit question_path(question)

      expect(page).to_not have_link 'Delete link'
    end
  end
end
