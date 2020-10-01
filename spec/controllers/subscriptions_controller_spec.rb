require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context 'unauthenticated user' do
      it 'does not create a subscription' do
        question.reload
        expect{ post :create, params: { question_id: question }, format: :js }.to_not change(user.subscriptions, :count)
      end

      it 'gets a response with forbidden status' do
        post :destroy, params: { question_id: question, format: :js }
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user' do
      before do
        login(user)
        post :create, params: { question_id: question, format: :js  }
        delete :destroy, params: { question_id: question, format: :js }
      end

      it 'deletes a subscription' do
        question.reload
        expect(question.subscriptions.count).to eq(0)
      end

      it 'deletes a subscription twice' do
        delete :destroy, params: { question_id: question, format: :js }
        question.reload
        expect(question.subscriptions.count).to eq(0)
      end

      it 'subscribes twice' do
        post :create, params: { question_id: question, format: :js  }
        post :create, params: { question_id: question, format: :js  }
        question.reload
        expect(question.subscriptions.count).to eq(1)
      end
    end

    context 'unauthenticated user' do
      it 'does not delete a subscription' do
        question.reload
        expect{ delete :destroy, params: { question_id: question }, format: :js }.to_not change(user.subscriptions, :count)
      end

      it 'gets a response with forbidden status' do
        delete :destroy, params: { question_id: question, format: :js }
        expect(response.status).to eq(401)
      end
    end
  end
end
