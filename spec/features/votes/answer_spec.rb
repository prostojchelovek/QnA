require 'rails_helper'

feature 'User can vote for a answer', %q{
  In order to rate favorite answer
  user as an authenticated user can vote
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:other_question) { create(:question, user: other_user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:other_answer) { create(:answer, question: other_question, user: other_user) }

  describe 'Authenticated user', js: true do
    before { sign_in(user) }
    before { visit question_path(other_question) }

    scenario 'can vote up' do
      within ".vote-answer-#{other_answer.id}" do
        click_on 'up'
        expect(page).to have_content '1'
      end
    end

    scenario 'can vote down' do
      within ".vote-answer-#{other_answer.id}" do
        click_on 'down'
        expect(page).to have_content '-1'
      end
    end
  end
end
