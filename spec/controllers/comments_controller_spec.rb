require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user, email: 'test@example.com', password: 'password', confirmed_at: Time.current, role: 'author') }
  let(:other_user) { create(:user, email: 'other@example.com', password: 'password', confirmed_at: Time.current, role: 'author') }
  let(:new_post) { create(:post, user: user) }
  let!(:comment) { create(:comment, post: new_post, user: user, body: 'Original comment') }

  before do
    sign_in user
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new comment' do
        expect {
          post :create, params: { post_id: new_post.id, comment: { body: 'This is a test comment' } }
        }.to change(Comment, :count).by(1)
      end

      it 'redirects to the post' do
        post :create, params: { post_id: new_post.id, comment: { body: 'This is a test comment' } }
        expect(response).to redirect_to(new_post)
        expect(flash[:notice]).to eq('Comment was successfully added.')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new comment' do
        expect {
          post :create, params: { post_id: new_post.id, comment: { body: '' } }
        }.not_to change(Comment, :count)
      end

      it 'redirects to the post with an alert' do
        post :create, params: { post_id: new_post.id, comment: { body: '' } }
        expect(response).to redirect_to(new_post)
        expect(flash[:alert]).to eq('Unable to add comment.')
      end
    end
  end

  describe 'GET #edit' do
    context 'when authorized' do
      it 'allows the user to edit their comment' do
        get :edit, params: { post_id: new_post.id, id: comment.id }
        expect(response).to be_successful
        expect(assigns(:comment)).to eq(comment)
      end
    end

    context 'when not authorized' do
      it 'redirects to the post with an alert' do
        other_comment = create(:comment, post: new_post, user: other_user)
        get :edit, params: { post_id: new_post.id, id: other_comment.id }
        expect(response).to redirect_to(new_post)
        expect(flash[:alert]).to eq('Not authorized')
      end
    end
  end

  describe 'PATCH #update' do
    context 'when authorized' do
      it 'updates the comment' do
        patch :update, params: { post_id: new_post.id, id: comment.id, comment: { body: 'Updated comment' } }
        comment.reload
        expect(comment.body).to eq('Updated comment')
        expect(response).to redirect_to(new_post)
        expect(flash[:notice]).to eq('Comment was successfully updated.')
      end
    end

    context 'when not authorized' do
      it 'does not update the comment' do
        other_comment = create(:comment, post: new_post, user: other_user)
        patch :update, params: { post_id: new_post.id, id: other_comment.id, comment: { body: 'Unauthorized update' } }
        expect(other_comment.reload.body).not_to eq('Unauthorized update')
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when authorized' do
      it 'deletes the comment' do
        expect {
          delete :destroy, params: { post_id: new_post.id, id: comment.id }
        }.to change(Comment, :count).by(-1)
      end

      it 'redirects to the post' do
        delete :destroy, params: { post_id: new_post.id, id: comment.id }
        expect(response).to redirect_to(new_post)
        expect(flash[:notice]).to eq('Comment was successfully deleted.')
      end
    end

    context 'when not authorized' do
      it 'does not delete the comment' do
        other_comment = create(:comment, post: new_post, user: other_user)
        expect {
          delete :destroy, params: { post_id: new_post.id, id: other_comment.id }
        }.not_to change(Comment, :count)
        expect(response).to redirect_to(new_post)  # Expect redirect to the post
        expect(flash[:alert]).to eq('Not authorized to delete this comment.')
      end
    end
  end
end
