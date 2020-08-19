require 'rails_helper'

feature 'User can delete answer attachments', %q{
  As an authenticated user
  I'd like to be able to delete attachments of my answer
  And no one except me can delete my attachments
} do

  given(:user) {create(:user)}
  given(:other_user) {create(:user)}
  given(:question) {create(:question, user: user)}
  given!(:other_user_question) {create(:question, user: other_user)}

  describe 'User' do
    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'answer body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Answer'
    end

    scenario 'is authenticated and trying to delete their attachment', js: true do
      click_on 'Delete file'
      expect(page).to_not have_content 'rails_helper.rb'
    end

    scenario "is authenticated and trying to delete someone else's attachment", js: true do
      click_on 'Logout'
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end

    scenario "is unauthenticated trying to delete attachment", js: true do
      click_on 'Logout'
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end
  end
end
