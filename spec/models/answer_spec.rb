require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  describe 'choose_the_best' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    it 'set true for a better answer' do
      create_list(:answer, 5, question: question, user: user)
      answer.choose_the_best

      expect(question.answers.where(best: true).count).to eq 1
      expect(question.answers.find_by(id: answer)).to be_best
    end
  end
end
