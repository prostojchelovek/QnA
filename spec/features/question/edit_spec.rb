require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:other_user) { create(:user) }
  given!(:other_question) { create(:question, user: other_user) }
  given!(:link) {'https://www.youtube.com/watch?v=x23aIQPa-DY'}

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edts his question', js: true do
      sign_in user
      visit question_path(question)

      within '.question' do
        click_on 'Edit question'
        fill_in 'Title', with: 'question title'
        fill_in 'Body', with: 'question body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'question title'
        expect(page).to have_content 'question body'
      end
    end

    scenario 'edits his question with errors', js: true do
      sign_in user
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      visit question_path(other_question)

      expect(page).to_not have_button 'Edit'
    end

    scenario 'adds his new links when editing a question', js: true do
      sign_in user
      visit question_path(question)

      within '.question' do
        click_on 'Edit question'
        click_on 'Add link'
        fill_in 'Link name', with: 'asdfghjk'
        fill_in 'Url', with: link
        click_on 'Save'
      end

      expect(page).to have_link 'asdfghjk', href: link
    end
  end
end
