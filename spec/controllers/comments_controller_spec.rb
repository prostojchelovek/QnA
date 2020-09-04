require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    describe 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'adds a new comment to question' do
          expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(question.comments, :count).by(1)
          expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(user.comments, :count).by(1)
        end

        it 'adds a new comment to answer' do
          expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js }.to change(answer.comments, :count).by(1)
          expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js }.to change(user.comments, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it "does't save the comment" do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js }.to_not change(Comment, :count)
          expect { post :create, params: { comment: attributes_for(:comment, :invalid), answer_id: answer }, format: :js }.to_not change(Comment, :count)
        end
      end
    end

    describe 'Unauthenticated user' do
      it 'tries create comment' do
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to_not change(Comment, :count)
        expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js }.to_not change(Comment, :count)
      end
    end
  end
end
