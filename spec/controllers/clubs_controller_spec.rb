require 'rails_helper'

RSpec.describe ClubsController, type: :controller do
  let(:admin_user) { create(:user, role: create(:role, name: 'admin')) }
  let(:club) { create(:club) }

  before do
    sign_in admin_user
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns clubs' do
      club
      get :index
      expect(assigns(:clubs)).to include(club)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: club.id }
      expect(response).to be_successful
    end

    it 'assigns the requested club' do
      get :show, params: { id: club.id }
      expect(assigns(:club)).to eq(club)
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new club' do
      get :new
      expect(assigns(:club)).to be_a_new(Club)
    end
  end

  describe 'GET #edit' do
    it 'returns a successful response' do
      get :edit, params: { id: club.id }
      expect(response).to be_successful
    end

    it 'assigns the requested club' do
      get :edit, params: { id: club.id }
      expect(assigns(:club)).to eq(club)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { { name: 'Test Club', description: 'Test Description' } }

    it 'creates a new Club' do
      expect {
        post :create, params: { club: valid_attributes }
      }.to change(Club, :count).by(1)
    end

    it 'redirects to the created club' do
      post :create, params: { club: valid_attributes }
      expect(response).to redirect_to(Club.last)
    end

    it 'associates the club with the creator' do
      post :create, params: { club: valid_attributes }
      expect(Club.last.users).to include(admin_user)
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) { { name: 'Updated Club', description: 'Updated Description' } }

    it 'updates the requested club' do
      patch :update, params: { id: club.id, club: new_attributes }
      club.reload
      expect(club.name).to eq('Updated Club')
      expect(club.description).to eq('Updated Description')
    end

    it 'redirects to the club' do
      patch :update, params: { id: club.id, club: new_attributes }
      expect(response).to redirect_to(club)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested club' do
      club
      expect {
        delete :destroy, params: { id: club.id }
      }.to change(Club, :count).by(-1)
    end

    it 'redirects to the clubs list' do
      delete :destroy, params: { id: club.id }
      expect(response).to redirect_to(clubs_url)
    end
  end

  describe 'GET #search_members' do
    let(:search_query) { 'test' }
    let!(:user) { create(:user, email: 'test@example.com') }

    it 'returns matching users' do
      get :search_members, params: { id: club.id, query: search_query }
      expect(assigns(:users)).to include(user)
    end

    it 'excludes existing members' do
      club.users << user
      get :search_members, params: { id: club.id, query: search_query }
      expect(assigns(:users)).not_to include(user)
    end
  end

  describe 'POST #add_member' do
    let(:user) { create(:user) }

    it 'adds the user as a member' do
      expect {
        post :add_member, params: { id: club.id, user_id: user.id }
      }.to change(club.users, :count).by(1)
    end

    it 'redirects to the club' do
      post :add_member, params: { id: club.id, user_id: user.id }
      expect(response).to redirect_to(club)
    end
  end
end
