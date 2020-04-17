FROM dannyben/alpine-ruby

RUN apk add --no-cache libsodium-dev
RUN gem install secret_hub --version 0.1.6

WORKDIR /app
VOLUME /app

ENTRYPOINT ["secrethub"]
