require 'rails_helper'

describe Web::OccupationsController, type: :controller do
  describe 'guest user' do
    let(:occupation) { create(:occupation) }

    describe 'PATCH #change_status' do
      it 'redirects to login page' do
        patch :change_status, params: { id: occupation, occupation: { status: 1 } }
        expect(response).to redirect_to(new_user_session_url)
      end

      it 'does not update record' do
        patch :change_status, params: { id: occupation, occupation: { status: 1 } }
        occupation.reload
        expect(occupation.status).not_to eq('finished')
      end
    end
  end

  describe 'authenticated user' do
    let(:user) { create(:user) }
    before { sign_in(user) }

    describe 'PATCH #change_status' do
      context 'own occupation' do
        let(:occupation) { create(:occupation, user: user) }

        it 'changes occupation status' do
          patch :change_status, params: { id: occupation, occupation: { status: 1 } }
          occupation.reload
          expect(occupation.status).to eq('finished')
        end

        it 'redirects to root url' do
          patch :change_status, params: { id: occupation, occupation: { status: 1 } }
          expect(response).to redirect_to(root_url)
        end
      end

      context "someone else's occupation" do
        let(:another_occupation) { create(:occupation) }

        it 'does not change database' do
          patch :change_status, params: { id: another_occupation, occupation: { status: 1 } }
          another_occupation.reload
          expect(another_occupation.status).not_to eq('finished')
        end

        it 'redirects back if referrer exists' do
          request.env["HTTP_REFERER"] = 'http://example.com'
          patch :change_status, params: { id: another_occupation, occupation: { status: 1 } }
          expect(response).to redirect_to('http://example.com')
        end

        it 'redirects to root url if referrer does not exist' do
          patch :change_status, params: { id: another_occupation, occupation: { status: 1 } }
          expect(response).to redirect_to(root_url)
        end
      end
    end
  end
end
