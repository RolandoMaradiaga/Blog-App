class CommentMailer < ApplicationMailer
  def notify_post_author(comment)
    @comment = comment
    @post = comment.post
    @user = @post.user

    mail(to: @user.email, subject: 'New Comment on Your Post')
  end
end
