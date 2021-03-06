#!/bin/sh

set -e -u

cd "${GITHUB_WORKSPACE}" || exit 1

TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"

echo '::group::🐶 Installing reviewdog ... https://github.com/reviewdog/reviewdog'
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b "${TEMP_PATH}" "${REVIEWDOG_VERSION}" 2>&1
echo '::endgroup::'

echo '::group::⚡️ Installing dotenv-linter ... https://github.com/dotenv-linter/dotenv-linter'
curl -sSfL https://raw.githubusercontent.com/dotenv-linter/dotenv-linter/master/install.sh | sh -s -- -b "${TEMP_PATH}" "${DOTENV_LINTER_VERSION}" 2>&1
echo '::endgroup::'

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo '::group:: Running ⚡️ dotenv-linter with reviewdog 🐶 ...'
# shellcheck disable=SC2086
dotenv-linter --quiet --no-color ${INPUT_DOTENV_LINTER_FLAGS} \
  | reviewdog -f=dotenv-linter \
    -name="${INPUT_TOOL_NAME}" \
    -reporter="${INPUT_REPORTER}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
    ${INPUT_REVIEWDOG_FLAGS}

last_exit_code=$?

echo '::endgroup::'

exit $last_exit_code
