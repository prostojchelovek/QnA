require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }
      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
        end

        it 'saves a new answer in the database by anauth user' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(user.answers, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
        end

        it 're-renders question view' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'Unauthenticated user' do
      it 'trying to create answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:other_user) { create(:user) }
    context 'Authenticated user' do
      context 'Author' do
        before { login(user) }

        it 'trying to delete their answer' do
          expect { delete :destroy, params: { id: answer } }.to change(user.answers, :count).by(-1)
        end

        it 'redirect' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'Not author' do
        before { login(other_user) }

        it "trying to delete someone else's question" do
          expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
        end

        it 'redirect' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(question)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'trying to delete the answer' do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'Unauthenticated user' do
      it 'trying to update the answer' do
        expect { patch :update, params: { id: answer, answer: { body: 'new body' } } }.not_to change(Answer, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
