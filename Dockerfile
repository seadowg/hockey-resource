FROM ruby:2.3.0

# Copy resource scripts
ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*

# Install Gems
RUN gem install bundle --no-rdoc --no-ri
ADD Gemfile /opt/resource/
WORKDIR /opt/resource
RUN bundle install --without development test
