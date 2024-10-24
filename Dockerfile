# Use the official Ruby image as the base
FROM ruby:3.3.0

# Set environment variables
ENV RAILS_ENV=production

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client

# Install bundler
RUN gem install bundler

# Set working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

COPY . .

# Precompile assets
RUN bundle exec rake assets:precompile

# Expose port 3000 to the outside
EXPOSE 3000

# Set up the entrypoint script
ENTRYPOINT ["./entrypoint.sh"]
