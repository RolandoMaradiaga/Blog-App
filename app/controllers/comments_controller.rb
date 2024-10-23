class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    authorize @comment
    if @comment.save
      CommentNotificationJob.perform_later(@comment)
      redirect_to @post, notice: 'Comment was successfully added.'
    else
      redirect_to @post, alert: 'Unable to add comment.'
    end
  end

  def edit
    @comment = @post.comments.find(params[:id])
    redirect_to @post, alert: 'Not authorized' unless @comment.user == current_user
  end

  def update
    @comment = @post.comments.find(params[:id])
    if @comment.user == current_user && @comment.update(comment_params)
      redirect_to @post, notice: 'Comment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    authorize @comment
    @comment.destroy
    redirect_to @post, notice: 'Comment was successfully deleted.'
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
