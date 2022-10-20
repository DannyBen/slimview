FROM dannyben/alpine-ruby

RUN gem install sinatra slim puma
COPY --chmod=755 slimview /usr/local/bin/

WORKDIR /docs

VOLUME /docs
EXPOSE 3000
ENTRYPOINT ["slimview"]