require 'rails_helper'

RSpec.shared_examples 'voted' do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:model) { described_class.controller_name.classify.constantize }

  before { login(user) }

  describe 'POST #vote_up' do
    context 'user is author of resource' do

      let!(:user_votable) { voted(model, user) }

      it 'try to add new vote' do
        expect { post :vote_up, params: { id: user_votable } }.to change(Vote, :count)
      end
    end

    context 'not author of resource' do
      before { login(other_user) }

      let!(:user_votable) { voted(model, user) }

      it 'try to add new vote' do
        expect { post :vote_up, params: { id: user_votable } }.to change(Vote, :count)
      end
    end
  end

  describe 'POST #vote_down' do
    context 'user is author of resource' do

      let!(:user_votable) { voted(model, user) }

      it 'try to add new disvote' do
        expect { post :vote_down, params: { id: user_votable } }.to change(Vote, :count)
      end
    end

    context 'not author of resource' do
      before { login(other_user) }

      let!(:user_votable) { voted(model, user) }

      it 'try to add new votedown' do
        expect { post :vote_down, params: { id: user_votable } }.to change(Vote, :count)
      end
    end
  end

  describe 'DELETE #cancel_vote' do
    context 'user can cancel his vote' do
      before { login(other_user) }

      let!(:user_votable) { voted(model, user) }

      it 'cancel vote' do
        post :vote_up, params: { id: user_votable }
        expect { delete :cancel_vote, params: { id: user_votable } }.to change(Vote, :count).by(-1)
      end
    end

    context 'user can not cancel other vote' do
      let(:new_user) { create(:user) }
      let!(:new_vote) { voted(model, new_user) }

      it "user can not cancel other user's vote" do
        expect { delete :cancel_vote, params: { id: new_vote } }.to_not change(Vote, :count)
      end
    end
  end
end
