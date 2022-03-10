# syntax=docker/dockerfile:1
FROM ruby:2.7.5
#RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
#build-essential libpq-dev # For MySQL (running in a separate container)
# Install and update dependencies
#RUN apt-get update -qq && apt-get install -y nodejs

RUN apt-get update -qq && \
  apt-get install -qq -y --no-install-recommends cron \
  nodejs && \
  rm -rf /var/lib/apt/lists/*

#ENV APP_HOME /usr/src/app
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_ENV development

# Add a docker user to sudoers
# RUN adduser --disabled-password --gecos '' docker
# RUN adduser docker sudo
# RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# USER docker

# Make a directory for our API
#RUN mkdir /chat-system-api

# Create and declare our working directory
WORKDIR /chat-system-api

# Copy our Gemfiles to install dependencies
COPY Gemfile* ./
#COPY Gemfile /chat-system-api/Gemfile
#COPY Gemfile.lock /chat-system-api/Gemfile.lock

# Install gems
RUN bundle install

# Copy our project inside
COPY . .

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Enable cron service and add our cron job to crontab using the "whenever" gem
#RUN sudo /usr/sbin/service cron start
#RUN bundle exec whenever --clear-crontab
#RUN bundle exec whenever --update-crontab --set environment='development'

#ENTRYPOINT [["/bin/bash", "-c", "/usr/sbin/service cron start"]
#ENTRYPOINT ["/bin/bash", "-c", "bundle exec whenever --update-crontab && cron -f"]
#RUN "bundle exec whenever --update-crontab && cron -f"
#CMD bash -c "bundle exec whenever --update-crontab && cron -f"

# Add a script to be executed every time the container starts.
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]

# Expose port 3000 for our server
EXPOSE 3000

# Configure the main process to run when running the image
#CMD ["rails", "server", "-b", "0.0.0.0"]
CMD ["bash"]
