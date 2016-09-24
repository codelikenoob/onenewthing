require 'rails_helper'

describe Web::ThingsController, type: :controller do

  shared_examples 'public access to things' do

    describe 'GET #index' do
      before(:each) { get :index }

      it { expect(response).to render_template(:index) }
      it { expect(assigns(:things)).to eq(Thing.all) }
    end

    describe 'GET #show' do
      let(:thing) { FactoryGirl.create(:thing) }
      before(:each) { get :show, params: { id: thing } }

      it { expect(response).to render_template(:show) }
      it { expect(assigns(:thing)).to eq(thing) }
    end
  end

  describe 'guest user' do
    it_behaves_like 'public access to things'
    let(:thing) { FactoryGirl.create(:thing) }

    describe 'CRUD methods' do
      context 'redirects to login page' do
        after(:each) { expect(response).to redirect_to(new_user_session_url) }
        it { get :new }
        it { post :create, params: { thing: FactoryGirl.attributes_for(:thing) } }
        it { get :edit, params: { id: thing } }
        it { patch :update, params: { id: thing,
                                      thing: FactoryGirl.attributes_for(:thing, title: 'New title')} }
        it { delete :destroy, params: { id: thing } }
      end
    end

    context 'does not touch database' do
      it 'POST #create' do
        expect {
          post :create, params: { thing: FactoryGirl.attributes_for(:thing) }
        }.not_to change(Thing, :count)
      end
      it 'PATCH #update' do
        patch :update, params: { id: thing,
                                 thing: FactoryGirl.attributes_for(:thing, title: 'New title')}
        thing.reload
        expect(thing.title).not_to eq('New title')
      end
      it 'DELETE #destroy' do
        delete :destroy, params: { id: thing }
        expect(Thing.exists?(thing.id)).to be_truthy
      end
    end
  end

  describe 'authenticated user' do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in(user) }
    it_behaves_like 'public access to things'

    describe 'GET #new' do
      before(:each) { get :new }
      it { expect(response).to render_template(:new) }
      it { expect(assigns(:thing)).to be_a_new(Thing) }
    end
    describe 'POST #create' do
      context 'valid data, unexisting thing' do
        let(:valid_data) { FactoryGirl.attributes_for(:thing) }

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
        let!(:thing) { FactoryGirl.create(:thing) }
        let(:valid_data) { FactoryGirl.attributes_for(:thing, title: thing.title) }

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
        let(:invalid_data) { FactoryGirl.attributes_for(:thing, title: '') }

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
      let(:thing) { FactoryGirl.create(:thing) }
      # TODO: resolve skip
      context 'redirects to pundit path', skip: 'define pundit path' do
        after(:each) { expect(response).to redirect_to(PUNDIT_PATH_HERE) }
        it { get :edit, params: { id: thing } }
        it { patch :update, params: { id: thing,
                                      thing: FactoryGirl.attributes_for(:thing, title: 'New title')} }
        it { delete :destroy, params: { id: thing } }
      end
      context 'does not change database' do
        it 'PATCH #update' do
          patch :update, params: { id: thing,
                                   thing: FactoryGirl.attributes_for(:thing, title: 'New title')}
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
      let(:thing) { FactoryGirl.create(:thing, users: [user]) }
      let(:thing_2) { FactoryGirl.create(:thing) }

      context 'redirects', skip: 'decide where to redirect users after actions' do
      end

      context 'assigns right things to instance var' do
        it 'GET #edit' do
          get :edit, params: { id: thing }
          expect(assigns(:thing)).to eq(thing)
        end
      end

      context 'touch database' do
        describe 'PATCH #update (title)' do
          it 'finds appropriate thing' do
            patch :update, params: { id: thing,
                                     thing: FactoryGirl.attributes_for(:thing, title: thins_2.title) }
            expect(thing.users).not_to include(user)
            expect(thing_2.users).to include(user)
          end
          it 'does not find appropriate thing' do
            patch :update, params: { id: thing,
                                     thing: FactoryGirl.attributes_for(:thing, title: 'very new title') }
            expect(thing.users).not_to include(user)
            expect(user.things.last.title).to eq('very new title')
          end
        end
        describe 'DELETE #destroy' do
          it 'deletes association' do
            delete :destroy, params: { id: thing }
            expect(thing.users).not_to include(user)
          end
        end
      end
    end

  end
end
