FROM alpine:3.11

ENV DOTENV_LINTER_VERSION v1.0.0
ENV REVIEWDOG_VERSION v0.9.17

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN apk add --no-cache git
RUN wget https://github.com/mgrachev/dotenv-linter/releases/download/$DOTENV_LINTER_VERSION/dotenv-linter-$DOTENV_LINTER_VERSION-alpine-x86_64.tar.gz -O - -q | tar -xzf -
RUN mv dotenv-linter /usr/local/bin/
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin/ $REVIEWDOG_VERSION

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
