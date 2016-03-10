FROM ruby:2.3.0

RUN gem install rest-client --no-rdoc --no-ri

ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*
