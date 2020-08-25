require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  describe '#choose_the_best' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:other_answer) { create(:answer, question: question, user: other_user) }
    let!(:badge) { create(:badge, question: question) }

    it 'set true for a better answer' do
      create_list(:answer, 5, question: question, user: user)
      answer.choose_the_best

      expect(question.answers.where(best: true).count).to eq 1
      expect(question.answers.find_by(id: answer)).to be_best
    end

    it 'adds badge to user' do
      other_answer.choose_the_best
      expect(question.badge.user).to eq other_user
    end
  end
end
