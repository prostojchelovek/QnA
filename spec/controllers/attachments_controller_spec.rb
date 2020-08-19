require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'DELETE #destroy' do
    before { question.files.attach(io: File.open("#{Rails.root.join('spec/rails_helper.rb')}"), filename: 'rails_helper.rb') }
    before { answer.files.attach(io: File.open("#{Rails.root.join('spec/rails_helper.rb')}"), filename: 'rails_helper.rb') }

    describe 'Authenticated user' do
      context 'author' do
        before { login(user) }

        it 'tries to delete file' do
          expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to change(answer.files, :count).by(-1)
          expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
        end
      end

      context 'not author' do
        before { login(other_user) }

        it 'tries to delete file' do
          expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to_not change(answer.files, :count)
          expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
        end
      end
    end

    it 'Unauthenticated user tries to delete file' do
      expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to_not change(answer.files, :count)
      expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
    end
  end
end
