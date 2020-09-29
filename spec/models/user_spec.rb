require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:badges).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe 'author of the answer' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    context 'valid' do
      it 'compares user and author' do
        expect(user).to be_author_of(answer)
      end
    end

    context 'invalid' do
      it 'compares user and author' do
        expect(other_user).to_not be_author_of(answer)
      end
    end
  end

  describe '#already_voted?' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    before { question.vote_up(other_user) }

    it 'user already voted the resource' do
      expect(other_user).to be_already_voted(question.id)
    end

    it 'user has not voted the resource' do
      expect(user).to_not be_already_voted(question.id)
    end
  end
end
