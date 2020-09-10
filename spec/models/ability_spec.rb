require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Link }
    it { should be_able_to :read, Vote }
    it { should_not be_able_to :read, Badge }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other_user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:other_answer) { create(:answer, question: other_question, user: other_user) }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'question' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, question }
      it { should_not be_able_to :update, other_question }

      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, other_question }

      it { should_not be_able_to :vote_down, question }
      it { should be_able_to :vote_down, other_question }

      it { should_not be_able_to :vote_up, question }
      it { should be_able_to :vote_up, other_question }

      it { should_not be_able_to :cancel_vote, question }
      it { should be_able_to :cancel_vote, other_question }
    end

    context 'answer' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, other_answer }

      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, other_answer }

      it { should_not be_able_to :vote_down, answer }
      it { should be_able_to :vote_down, other_answer }

      it { should_not be_able_to :vote_up, answer }
      it { should be_able_to :vote_up, other_answer }

      it { should_not be_able_to :cancel_vote, answer }
      it { should be_able_to :cancel_vote, other_answer }

      it { should be_able_to :choose_the_best, answer }
      it { should_not be_able_to :choose_the_best, other_answer }
    end

    context 'link' do
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question) }
    end

    context 'comment' do
      it { should be_able_to :create, Comment }
    end

    context 'attachment' do
      before do
        question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
        other_question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
        answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
        other_answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      end

      it { should be_able_to :destroy, answer.files.first }
      it { should_not be_able_to :destroy, other_answer.files.first }

      it { should be_able_to :destroy, question.files.first }
      it { should_not be_able_to :destroy, other_question.files.first }
    end
  end
end
