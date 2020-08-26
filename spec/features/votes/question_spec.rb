require 'rails_helper'

feature 'User can vote for a question', %q{
  In order to rate favorite question
  user as an authenticated user can vote
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question, user: other_user) }

  describe 'Authenticated user', js: true do
    before { sign_in(user) }
    before { visit question_path(other_question) }

    scenario 'can vote up' do
      within ".vote-question-#{other_question.id}" do
        click_on 'up'
        expect(page).to have_content '1'
      end
    end

    scenario 'can vote down' do
      within ".vote-question-#{other_question.id}" do
        click_on 'down'
        expect(page).to have_content '-1'
      end
    end

    scenario 'can vote only once' do
      within ".vote-question-#{other_question.id}" do
        click_on 'down'
        click_on 'up'
        click_on 'up'
        expect(page).to have_content '-1'
      end
    end

    scenario "Author can't vote for their answer" do
      click_on 'Logout'
      sign_in(user)
      visit question_path(question)

      within ".question" do
        expect(page).to_not have_content 'down'
        expect(page).to_not have_content 'up'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario "can't vote for the answer" do
      visit question_path(question)

      within ".question" do
        expect(page).to_not have_content 'down'
        expect(page).to_not have_content 'up'
      end
    end
  end
end
