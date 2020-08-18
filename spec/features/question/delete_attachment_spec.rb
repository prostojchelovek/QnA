require 'rails_helper'

feature 'User can delete question attachments', %q{
  As an authenticated user
  I'd like to be able to delete attachments of my question
  And no one except me can delete my attachments
} do

  given(:user) {create(:user)}
  given(:other_user) {create(:user)}
  given(:question) {create(:question, user: user)}

  describe 'User' do
    background do
      sign_in(user)
      visit question_path(question)

      within ".question" do
        click_on 'Edit'
        fill_in 'Title', with: 'question title'
        fill_in 'Body', with: 'question body'
        attach_file 'File', ["#{Rails.root}/README.md"]
        click_on 'Save'
      end
    end

    scenario 'is authenticated and trying to delete their attachment', js: true do
      click_on 'Delete file'
      expect(page).to_not have_content 'README.md'
    end

    scenario "is authenticated and trying to delete someone else's attachment", js: true do
      click_on 'Logout'
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_content 'Delete file'
    end

    scenario "is unauthenticated and trying to delete attachment", js: true do
      click_on 'Logout'
      visit question_path(question)

      expect(page).to_not have_content 'Delete file'
    end
  end
end
