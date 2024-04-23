# syntax=docker/dockerfile:1
FROM ruby:2.7.5

RUN apt-get update -qq && \
  apt-get install -qq -y --no-install-recommends cron \
  nodejs && \
  rm -rf /var/lib/apt/lists/*

ARG RAILS_ENV=development
# Just for the task's purposes
ENV RAILS_LOG_TO_STDOUT true
# Set to development just for the task's purposes
ENV RAILS_ENV ${RAILS_ENV}
  
# Create and declare our working directory
WORKDIR /chat-system

# Copy our Gemfiles to install dependencies
COPY Gemfile* ./

# Install gems
RUN bundle install

# Copy our project inside
COPY . .

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Expose port 3000 for our server
EXPOSE 3000

# Configure the main process to run when running the image
ENTRYPOINT ["entrypoint.sh", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]