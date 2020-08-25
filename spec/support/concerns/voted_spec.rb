require 'rails_helper'

RSpec.shared_examples 'voted' do
  let(:user) { create(:user) }
  let(:model) { described_class.controller_name.classify.constantize }

  before { login(user) }

  describe 'POST #vote_up' do
    context 'user is author of resource' do

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
  end
end
