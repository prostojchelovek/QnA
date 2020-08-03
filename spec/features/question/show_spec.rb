require 'rails_helper'

feature 'User can view the question and answers to it', %q{
  To find the answer to the question
  I'd like to view a list of answers to the it
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given!(:answers) {create_list(:answer, 10, user: user, question: question)}

  scenario 'User tries to view the question and answers to it' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
