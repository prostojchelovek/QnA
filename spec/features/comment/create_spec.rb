require 'rails_helper'

feature 'User can add comment' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'comments the question with valid data' do
      within ".question" do
        fill_in 'Your comment', with: 'Comment body'
        click_on 'Add comment'
      end

      expect(current_path).to eq question_path(question)
      within '.question' do
        expect(page).to have_content 'Comment body'
      end
    end

    scenario 'comments the answer with valid data' do
      within "#answer-#{answer.id}" do
        fill_in 'Your comment', with: 'Comment body'
        click_on 'Add comment'
      end

      expect(current_path).to eq question_path(question)
      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Comment body'
      end
    end

    scenario 'comments the question with invalid data' do
      within '.question' do
        fill_in 'Your comment', with: nil
        click_on 'Add comment'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'comments the answer with invalid data' do
      within "#answer-#{answer.id}" do
        fill_in 'Your comment', with: nil
        click_on 'Add comment'
      end
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to comment question or answer' do
      visit question_path(question)
      expect(page).to_not have_content 'Add comment'
    end
  end

  context 'multiple sessions' do
    scenario "answer comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within "#answer-#{answer.id}" do
          fill_in 'Your comment', with: 'Comment body'
          click_on 'Add comment'
        end

        within "#answer-#{answer.id}" do
          expect(page).to have_content 'Comment body'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Comment body'
      end
    end

    scenario "question comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question' do
          fill_in 'Your comment', with: 'Comment body'
          click_on 'Add comment'
        end

        within '.question' do
          expect(page).to have_content 'Comment body'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Comment body'
      end
    end
  end
end
