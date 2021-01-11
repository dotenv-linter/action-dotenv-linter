FROM alpine:3.11

ENV DOTENV_LINTER_VERSION v3.0.0
ENV REVIEWDOG_VERSION v0.11.0

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN apk add --no-cache git
RUN wget -q -O - https://raw.githubusercontent.com/dotenv-linter/dotenv-linter/master/install.sh | sh -s -- -b /usr/local/bin/ $DOTENV_LINTER_VERSION
RUN wget -q -O - https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin/ $REVIEWDOG_VERSION

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
