require 'rails_helper'

describe Web::OccupationsController, type: :controller do
  let(:user) { create(:user) }
  let(:thing) { create(:thing) }
  let(:occupation) { Occupation.create(user: user, thing: thing, status: "in_progress") }

  describe 'guest user' do
    describe 'PATCH #change_status' do
      it 'redirects to login page' do
        patch :change_status, params: { occupation: { id: occupation, status: 1 } }
        expect(response).to redirect_to(new_user_session_url)
      end

      it 'does not update record' do
        patch :change_status, params: { occupation: { id: occupation, status: 1 } }
        occupation.reload
        expect(occupation.status).not_to eq("finished")
      end
    end
  end

  describe 'authenticated user' do
    before { sign_in(user) }

    describe 'PATCH #change_status' do
      context 'with user occupation' do
        it 'changes occupation status' do
          patch :change_status, params: { occupation: { id: occupation, status: 1 } }
          occupation.reload
          expect(occupation.status).to eq("finished")
        end

        it 'redirects to root path' do
          patch :change_status, params: { occupation: { id: occupation, status: 1 } }
          expect(response).to redirect_to(root_path)
        end
      end

      context 'with another occupation' do
        let(:another_user) { create(:user) }
        let(:another_thing) { create(:thing) }
        let(:another_occupation) { Occupation.create(user: another_user, thing: another_thing, status: "in_progress") }

        it 'can not change occupation status' do
          expect { 
            patch :change_status, params: { occupation: { id: another_occupation, status: 1 } }
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end