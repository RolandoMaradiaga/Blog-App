class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    if params[:query].present?
      @posts = Post.search_by_title_and_body(params[:query])
    else
      @posts = Post.all
    end
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      Rails.cache.delete_matched("views/posts/*")
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
end

  def edit
    redirect_to posts_path, alert: 'Not authorized' unless @post.user == current_user
  end

  def update
    if @post.user == current_user && @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @post.user == current_user
      @post.destroy
      redirect_to posts_path, notice: 'Post was successfully deleted.'
    else
      redirect_to posts_path, alert: 'Not authorized'
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
