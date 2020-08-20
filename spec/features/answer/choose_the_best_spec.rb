require 'rails_helper'

feature 'User can choose the best answer', %q{
  In order to indicate a solution to the problem
  As an author of question
  I'd like ot be able to mark the right answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 10, question: question, user: user) }
  given!(:other_user) { create(:user) }
  given!(:other_question) { create(:question, user: other_user) }

  scenario 'Unauthenticated can not choose the best answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Best'
  end

  describe 'Authenticated user' do
    describe 'author' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario "sees the best answer first", js: true do  
        within("#answer-#{answers.last.id}") { click_on 'Best' }
        first_answer = find('.answers').first(:element)
        best_answer = answers.last.body
        within first_answer do
          expect(page).to have_content best_answer
        end
      end

      scenario 'chooses the best answer', js: true do
        first('.best-answer').click
        expect(page).to have_css('.best', count: 1)
      end

      scenario 'chooses another best answer', js: true do
        within "#answer-#{answers.first.id}" do
          click_on 'Best'
      end
        within "#answer-#{answers.second.id}" do
          click_on 'Best'
      end
        expect(page).to have_css('.best', count: 1)
      end
    end

    describe 'not author' do
      scenario "does not see the link" do
        sign_in(other_user)
        visit question_path(question)
        expect(page).to_not have_link 'Best'
      end
    end
  end
end
