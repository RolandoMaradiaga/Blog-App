module Api
  module V1
    class PostsController < ApplicationController
      before_action :set_post, only: %i[show update destroy]
      before_action :authenticate_user!, except: %i[index show]

      def index
        @posts = Post.page(params[:page]).per(10)
        render json: @posts
      end

      def show
        render json: @post
      end

      def create
        @post = current_user.posts.build(post_params)
        if @post.save
          render json: @post, status: :created
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      def update
        if @post.update(post_params)
          render json: @post
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @post.destroy
        head :no_content
      end

      private

      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(:title, :body)
      end
    end
  end
end
