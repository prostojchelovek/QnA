require 'rails_helper'

feature 'User can create answer to the question', %q{
  In order to help a community solve the problems
  As an authenticated user
  Being on the question page
  I'd like to be able to answer the questions
} do

  given(:user) {create(:user)}
  given(:question) {create(:question, user: user)}

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'create an answer' do
      fill_in 'Body', with: 'text text'
      click_on 'Answer'

      expect(page).to have_content 'text text'
    end

    scenario 'create a answer with errors' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'create an answer with attached file' do
      fill_in 'Body', with: 'Test answer'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to answer the question', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'text text'
    expect(page).to_not have_content 'Logout'
    expect(page).to_not have_link 'Delete question'
  end
end
