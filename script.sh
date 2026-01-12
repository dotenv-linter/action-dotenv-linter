#!/bin/sh

set -e -u

cd "${GITHUB_WORKSPACE}" || exit 1

TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"

echo '::group::🐶 Installing reviewdog ... https://github.com/reviewdog/reviewdog'
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh \
  | sh -s -- -b "${TEMP_PATH}" "${REVIEWDOG_VERSION}" 2>&1
echo '::endgroup::'

echo '::group::⚡️ Installing dotenv-linter ... https://github.com/dotenv-linter/dotenv-linter'
curl -sSfL https://raw.githubusercontent.com/dotenv-linter/dotenv-linter/master/install.sh \
  | sh -s -- -b "${TEMP_PATH}" "${DOTENV_LINTER_VERSION}" 2>&1
echo '::endgroup::'

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [ "${INPUT_REPORTER}" = "github-code-suggestions" ]
then
      echo '::group::Running ⚡️ dotenv-linter with code suggestions 🐶 ...'
      # shellcheck disable=SC2086
      dotenv-linter fix --plain ${INPUT_DOTENV_LINTER_FLAGS} .

      TMPFILE=$(mktemp)
      git diff > "${TMPFILE}"
      git stash -u || true
      git stash drop || true

      # shellcheck disable=SC2086
      reviewdog \
        -name="${INPUT_TOOL_NAME}" \
        -f=diff \
        -f.diff.strip=1 \
        -reporter="github-pr-review" \
        -filter-mode="${INPUT_FILTER_MODE}" \
        -fail-level="${INPUT_FAIL_LEVEL}" \
        ${INPUT_REVIEWDOG_FLAGS} < "${TMPFILE}"
else
      echo '::group::Running ⚡️ dotenv-linter with reviewdog 🐶 ...'
      # shellcheck disable=SC2086
      dotenv-linter check --quiet --plain ${INPUT_DOTENV_LINTER_FLAGS} . \
        | reviewdog -f=dotenv-linter \
          -name="${INPUT_TOOL_NAME}" \
          -reporter="${INPUT_REPORTER}" \
          -filter-mode="${INPUT_FILTER_MODE}" \
          -fail-level="${INPUT_FAIL_LEVEL}" \
          ${INPUT_REVIEWDOG_FLAGS}
fi

EXIT_CODE=$?
echo '::endgroup::'
exit ${EXIT_CODE}
