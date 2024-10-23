class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :show]

  def index
    if params[:query].present?
      @posts = Post.includes(:user).search_by_title_and_body(params[:query]).page(params[:page]).per(10)
    else
      @posts = Post.includes(:user).page(params[:page]).per(10)
    end
  end

  def show
    @post = Post.includes(:user, comments: :user).find(params[:id])
  end

  def new
    @post = current_user.posts.build
    authorize @post
  end

  def create
    @post = current_user.posts.build(post_params)
    authorize @post
    if @post.save
      Rails.cache.delete_matched("views/posts/*")
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def edit
    authorize @post, :edit?
  end

  def update
    authorize @post
    if @post.update(post_params)
      Rails.cache.delete_matched("views/posts/*")
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @post
    @post.destroy
    Rails.cache.delete_matched("views/posts/*")
    redirect_to posts_path, notice: 'Post was successfully deleted.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end
end