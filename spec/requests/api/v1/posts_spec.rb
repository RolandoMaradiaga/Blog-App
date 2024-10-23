require 'rails_helper'

RSpec.describe 'API::V1::Posts', type: :request do
  describe 'GET /api/v1/posts' do
    it 'returns all posts' do
      create_list(:post, 5)
      get '/api/v1/posts'

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(5)
    end
  end
end
