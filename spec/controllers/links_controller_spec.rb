require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:link) { create :link, name: 'link_name', url: 'https://github.com/nathanvda/cocoon/pull/454', linkable: question }
  let(:other_user) { create(:user) }

  describe 'DELETE #destroy' do
    context 'Authenticate user' do
      context 'author' do
        before { login(user) }

        it 'removes link' do
          expect { delete :destroy, params: { id: link.id }, format: :js }.to change(Link, :count).by(-1)
        end
      end

      context 'not the author' do
        before { login(other_user) }

        it 'not removes link' do
          expect { delete :destroy, params: { id: link.id }, format: :js }.to_not change(Link, :count)
        end
      end
    end

    context 'Unauthenticate user' do
      it 'not removes link' do
        expect { delete :destroy, params: { id: link.id }, format: :js }.to_not change(Link, :count)
      end
    end
  end
end
