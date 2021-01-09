#!/bin/sh

cd "$GITHUB_WORKSPACE" || exit
export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

dotenv-linter --quiet --no-color "${INPUT_DOTENV_LINTER_FLAGS}" \
  | reviewdog -f=dotenv-linter \
    -name="${INPUT_TOOL_NAME}" \
    -reporter="${INPUT_REPORTER}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
    -level="${INPUT_LEVEL}" \
    "${INPUT_REVIEWDOG_FLAGS}"
