require 'rails_helper'

feature 'User can delete question attachments', %q{
  As an authenticated user
  I'd like to be able to delete attachments of my question
  And no one except me can delete my attachments
} do

  given(:user) {create(:user)}
  given(:other_user) {create(:user)}
  given!(:question) {create(:question, user: user)}

  describe 'Authenticated user' do
    scenario 'is trying to delete their attachment', js: true do
      sign_in(user)
      visit question_path(question)

      within ".question" do
        click_on 'Edit'
        fill_in 'Title', with: 'question title'
        fill_in 'Body', with: 'question body'
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Save'
      end

      click_on "Delete file"
      expect(page).to_not have_content 'rails_helper.rb'
    end

    scenario "is trying to delete someone else's question", js: true do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario "Other user is trying to delete attachment", js: true do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete file'
  end

  scenario "Unauthenticated user is trying to delete attachment", js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Delete file'
  end
end
