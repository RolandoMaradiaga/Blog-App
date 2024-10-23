require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user, email: 'test@example.com', password: 'password', confirmed_at: Time.current, role: 'author') }
  let(:other_user) { create(:user) }
  let!(:new_post) { create(:post, user: user) }

  before do
    sign_in user
    puts "Warden user: #{request.env['warden'].user(:user).inspect}"
  end

  let(:valid_session) { {} }

  after do
    Warden.test_reset!
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @posts' do
      get :index
      expect(assigns(:posts)).to eq([new_post])
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: new_post.id }
      expect(response).to be_successful
    end

    it 'assigns @post' do
      get :show, params: { id: new_post.id }
      expect(assigns(:post)).to eq(new_post)
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new @post' do
      get :new
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new post' do
        expect {
          post :create, params: { post: { title: 'Test Post', body: 'This is a test post' } }
        }.to change(Post, :count).by(1)
      end

      it 'redirects to the created post' do
        post :create, params: { post: { title: 'New Post', body: 'Post body' } }
        expect(response).to redirect_to(Post.last)
      end
    end
  end

  context 'with invalid attributes' do
    it 'does not create a new post' do
      expect {
        post :create, params: { post: { title: '', body: '' } }
      }.not_to change(Post, :count)
    end

    it 'renders the new template' do
      post :create, params: { post: { title: '', body: '' } }
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    context 'when authorized' do
      it 'returns a successful response' do
        get :edit, params: { id: new_post.id }
        expect(response).to be_successful
      end
    end

    context 'when not authorized' do
      it 'redirects to root path' do
        other_post = create(:post, user: other_user)
        get :edit, params: { id: other_post.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

end
