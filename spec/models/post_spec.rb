require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'is valid with a title, body, and user' do
    post = build(:post)
    expect(post).to be_valid
  end

  it 'is invalid without a title' do
    post = build(:post, title: nil)
    expect(post).not_to be_valid
  end
end
