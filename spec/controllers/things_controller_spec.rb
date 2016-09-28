require 'rails_helper'

describe Web::ThingsController, type: :controller do

  shared_examples 'public access to things' do
    describe 'GET #index' do
      before(:each) { get :index }
      it { expect(response).to render_template(:index) }
      it { expect(assigns(:things)).to eq(Thing.all) }
    end
    describe 'GET #show' do
      let(:thing) { create(:thing) }
      before(:each) { get :show, params: { id: thing } }
      it { expect(response).to render_template(:show) }
      it { expect(assigns(:thing)).to eq(thing) }
    end
  end

  describe 'guest user' do
    it_behaves_like 'public access to things'
    let(:thing) { create(:thing) }
    describe 'CRUD methods' do
      context 'redirects to login page' do
        after(:each) { expect(response).to redirect_to(new_user_session_url) }
        it { get :new }
        it { post :create, params: { thing: attributes_for(:thing) } }
        it { get :edit, params: { id: thing } }
        it { patch :update, params: { id: thing,
                                      thing: attributes_for(:thing, title: 'New title')} }
        it { delete :destroy, params: { id: thing } }
      end

      context 'does not touch database' do
        it 'POST #create' do
          expect {
            post :create, params: { thing: attributes_for(:thing) }
          }.not_to change(Thing, :count)
        end
        it 'PATCH #update' do
          patch :update, params: { id: thing,
                                   thing: attributes_for(:thing, title: 'New title')}
          thing.reload
          expect(thing.title).not_to eq('New title')
        end
        it 'DELETE #destroy' do
          delete :destroy, params: { id: thing }
          expect(Thing.exists?(thing.id)).to be_truthy
        end
      end

    end
  end

  describe 'authenticated user' do
    let(:user) { create(:user) }
    before { sign_in(user) }
    it_behaves_like 'public access to things'
    describe 'GET #new' do
      before(:each) { get :new }
      it { expect(response).to render_template(:new) }
      it { expect(assigns(:thing)).to be_a_new(Thing) }
    end
    describe 'POST #create' do

      context 'valid data, unexisting thing' do
        let(:valid_data) { attributes_for(:thing) }
        it 'redirects to thing#show' do
          post :create, params: { thing: valid_data }
          # not using assigns[:thing], because creating of thing goes in service
          # object, and there is no reason to create instance variable
          expect(response).to redirect_to(thing_path(Thing.find_by_title(valid_data[:title])))
        end
        it 'creates new record in database' do
          expect {
            post :create, params: { thing: valid_data }
          }.to change(Thing, :count).by(1)
        end
        it 'associates user and new thing' do
          post :create, params: { thing: valid_data }
          expect(user.things.last.title).to eq(valid_data[:title])
        end
      end

      context 'vaild data, existing thing' do
        let!(:thing) { create(:thing) }
        let(:valid_data) { attributes_for(:thing, title: thing.title) }
        it 'redirects to thing#show' do
          post :create, params: { thing: valid_data }
          # not using assigns[:thing], because creating of thing goes in service
          # object, and there is no reason to create instance variable
          expect(response).to redirect_to(thing_path(Thing.find_by_title(valid_data[:title])))
        end
        it 'does not create new record in database' do
          expect {
            post :create, params: { thing: valid_data }
          }.not_to change(Thing, :count)
        end
        it 'associates user and existing thing' do
          post :create, params: { thing: valid_data }
          expect(user.things).to include(thing)
        end
        it 'does not associate user if already associated' do
          user.things << thing
          expect {
            post :create, params: { thing: valid_data }
          }.not_to change(user.things, :count)
        end
      end

      context 'invalid data' do
        let(:invalid_data) { attributes_for(:thing, title: '') }
        it 'renders :new template' do
          post :create, params: { thing: invalid_data }
          expect(response).to render_template(:new)
        end
        it 'does not create new record in database' do
          expect {
            post :create, params: { thing: invalid_data }
          }.not_to change(Thing, :count)
        end
      end
    end

    context 'user is not occupied thing' do
      let(:thing) { create(:thing) }

      context 'redirects to pundit path' do
        after(:each) { expect(response).to redirect_to(root_path) }
        it { get :edit, params: { id: thing } }
        it { patch :update, params: { id: thing,
                                      thing: attributes_for(:thing, title: 'New title')} }
        it { delete :destroy, params: { id: thing } }
      end

      context 'does not change database' do
        it 'PATCH #update' do
          patch :update, params: { id: thing,
                                   thing: attributes_for(:thing, title: 'New title')}
          thing.reload
          expect(thing.title).not_to eq('New title')
        end
        it 'DELETE #destroy' do
          delete :destroy, params: { id: thing }
          expect(Thing.exists?(thing.id)).to be_truthy
        end
      end

    end

    context 'user is occupied thing' do
      let!(:thing) { create(:thing, users: [user]) }
      let!(:thing_2) { create(:thing) }

      context 'assigns right things to instance var and renders' do
        describe 'GET #edit' do
          before(:each) { get :edit, params: { id: thing } }
          it { expect(assigns(:thing)).to eq(thing) }
          it { expect(response).to render_template(:edit) }
        end
      end

      context 'redirects' do
        describe 'PATCH #update' do
          it 'finds appropriate thing' do
            patch :update, params: { id: thing,
                                     thing: attributes_for(:thing, title: thing_2.title) }
            expect(response).to redirect_to(thing_path(thing_2))
          end
          it 'does not find appropriate thing' do
            patch :update, params: { id: thing,
                                     thing: attributes_for(:thing, title: 'very new title') }
            expect(response).to redirect_to(thing_path(user.things.last))
          end
        end
        describe 'DELETE #destroy' do
          # TODO
          it "redirects to user's dashboard"
        end
      end

      context 'touch database' do
        describe 'PATCH #update (title)' do
          it 'finds appropriate thing' do
            patch :update, params: { id: thing,
                                     thing: attributes_for(:thing, title: thing_2.title) }
            thing.reload
            expect(thing.users).not_to include(user)
            expect(thing_2.users).to include(user)
          end
          it 'does not find appropriate thing' do
            patch :update, params: { id: thing,
                                     thing: attributes_for(:thing, title: 'very new title') }
            thing.reload
            expect(thing.users).not_to include(user)
            expect(user.things.last.title).to eq('very new title')
          end
        end
        describe 'DELETE #destroy' do
          it 'deletes association' do
            delete :destroy, params: { id: thing }
            thing.reload
            expect(thing.users).not_to include(user)
          end
        end
      end

      context 'does not touch database' do
        describe 'PATCH #update' do
          it 'renders :edit template' do
            patch :update, params: { id: thing,
                                     thing: attributes_for(:thing, title: '') }
            expect(response).to render_template(:edit)
          end
          it 'finds appropriate thing' do
            patch :update, params: { id: thing,
                                     thing: attributes_for(:thing, title: '') }
            thing.reload
            expect(thing.users).to include(user)
            expect(user.things.last.title).not_to eq('')
          end
        end
      end

    end
  end
end
