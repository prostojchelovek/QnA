require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

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
end
