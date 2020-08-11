require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }
    let!(:answer) { create(:answer, question: question, user: user) }

    it 'the answer is associated with the question' do
      expect(assigns(:question)).to eq answer.question
    end

    it 'assigns a new Answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'Authenticated user' do
      before { login(user) }
      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'render new view' do
        expect(response).to render_template :new
      end
    end

    context 'Unauthenticated user' do
      before { get :new }
      it 'trying to render new view' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end


  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }
      context 'with valid attributes' do
        it 'saves a new question in the database by auth user' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context 'Unauthenticated user' do
      it 'trying to save the question to the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.not_to change(Question, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      before { login(user) }
      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'redirects to updated question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes  ' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }
        it 'does not change question' do
          question.reload

          expect(question.title).to eq question.title
          expect(question.body).to eq 'MyText'
        end

        it 're-renders edit view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'Unauthenticated user' do
      it 'trying to change the question' do
        patch :update, params: { id: question,  question: attributes_for(:question) }
        expect(assigns(:question)).not_to eq question
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:other_user) { create(:user) }

    context 'Authenticated user' do
      context 'Author' do
        before { login(user) }

        it 'trying to delete their question' do
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end

        it 'trying to delete their question' do
          expect { delete :destroy, params: { id: question } }.to change(user.questions, :count).by(-1)
        end

        it 'redirects to index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'Not author' do
        before { login(other_user) }

        it "trying to delete someone else's question" do
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end

        it 'redirects to index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end
    end

    context 'Unauthenticated user' do
      it 'trying to delete the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
