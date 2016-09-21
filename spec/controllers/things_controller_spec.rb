require 'rails_helper'

describe Web::ThingsController, type: :controller do

  shared_examples 'public access to things' do
    describe 'GET #index' do
      before(:each) { get :index }

      it { expect(response).to render_template(:index) }
      it { expect(assigns(:quests)).to eq(Quest.all) }
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
end
