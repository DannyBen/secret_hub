FROM dannyben/alpine-ruby:3.2.2

RUN apk add --no-cache libsodium-dev
RUN gem install secret_hub --version 0.2.2

WORKDIR /app
VOLUME /app

ENTRYPOINT ["secrethub"]
