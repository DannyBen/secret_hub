FROM dannyben/alpine-ruby

RUN apk add --no-cache libsodium-dev
RUN gem install secret_hub --version 0.2.1

WORKDIR /app
VOLUME /app

ENTRYPOINT ["secrethub"]
