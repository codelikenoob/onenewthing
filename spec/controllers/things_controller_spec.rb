require 'rails_helper'

describe Web::ThingsController, type: :controller do

  shared_examples 'public access to things' do
    describe 'GET #index' do
      before(:each) { get :index }

      it { expect(response).to render_template(:index) }
      it { expect(assigns(:thing)).to eq(Thing.all) }
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
        }.not_to change(Thing, :cont)
      end
      it 'PATCH #update' do
        patch :update, params: { id: thing,
                                 thing: FactoryGirl.attributes_for(:thing, title: 'New title')} }
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
      context 'valid data' do
        let(:valid_data) { FactoryGirl.attributes_for(:thing) }

        it 'redirects to thing#show' do
          post :create, params: { thing: valid_data }
          expect(response).to redirect_to(thing_path(assigns[:thing]))
        end
        it 'creates new record in database' do
          expect {
            post :create, params: { thing: valid_data }
          }.to change(Thing, :count).by(1)
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
  end
end
