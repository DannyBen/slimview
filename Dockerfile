FROM dannyben/alpine-ruby:4.0

RUN gem install slimview -v 0.2.2

WORKDIR /docs
VOLUME /docs
EXPOSE 3000

ENTRYPOINT ["slimview"]
