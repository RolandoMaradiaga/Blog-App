require 'rails_helper'

RSpec.describe CommentNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:comment) { create(:comment, post: post, user: user) }

  it 'queues the job' do
    expect {
      CommentNotificationJob.perform_later(comment)
    }.to have_enqueued_job.with(comment)
  end
end
