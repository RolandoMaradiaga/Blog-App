class CommentNotificationJob < ApplicationJob
  queue_as :default

  def perform(comment)
    CommentMailer.notify_post_author(comment).deliver_later
  end
end
