FROM ruby:2.3.0

ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*
