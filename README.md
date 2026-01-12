# GitHub Action: Run dotenv-linter with reviewdog 🐶

[![](https://github.com/dotenv-linter/action-dotenv-linter/workflows/CI/badge.svg)](https://github.com/dotenv-linter/action-dotenv-linter/actions?query=workflow%3ACI)
[![](https://img.shields.io/github/license/dotenv-linter/action-dotenv-linter)](./LICENSE)
[![depup](https://github.com/dotenv-linter/action-dotenv-linter/workflows/depup/badge.svg)](https://github.com/dotenv-linter/action-dotenv-linter/actions?query=workflow%3Adepup)
[![release](https://github.com/dotenv-linter/action-dotenv-linter/workflows/release/badge.svg)](https://github.com/dotenv-linter/action-dotenv-linter/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/dotenv-linter/action-dotenv-linter?logo=github&sort=semver)](https://github.com/dotenv-linter/action-dotenv-linter/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

This action runs [dotenv-linter](https://github.com/dotenv-linter/dotenv-linter) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to lint `.env` files.

## Examples

### With `github-pr-check`

By default, with `reporter: github-pr-check` an annotation is added to the line:

![Example comment made by the action, with github-pr-check](examples/example-github-pr-check.png)

### With `github-pr-review`

With `reporter: github-pr-review` a comment is added to the Pull Request Conversation:

![Example comment made by the action, with github-pr-review](examples/example-github-pr-review.png)

### With `github-code-suggestions`

With `reporter: github-code-suggestions` a code suggestion is added to the Pull Request Conversation:

![Example comment made by the action, with github-code-suggestions](examples/example-github-code-suggestions.png)

## Inputs

### `github_token`

`GITHUB_TOKEN`. Default is `${{ github.token }}`.

### `dotenv_linter_flags`

Optional. `dotenv-linter` flags. (`dotenv-linter <dotenv_linter_flags>`)

### `tool_name`

Optional. Tool name to use for reviewdog reporter. Useful when running multiple
actions with different config.

### `reporter`

Optional. Reporter of reviewdog command [`github-pr-check`, `github-pr-review`, `github-code-suggestions`].
The default is `github-pr-check`.

### `filter_mode`

Optional. Filtering mode for the reviewdog command [`added`, `diff_context`, `file`, `nofilter`].
Default is `added`.

### `fail_level`

Optional. If set to `none`, always use exit code 0 for reviewdog. Otherwise, exit code 1 for reviewdog if it finds at least 1 issue with severity greater than or equal to the given level.
Possible values: [`none`, `any`, `info`, `warning`, `error`]
Default is `none`.

### `fail_on_error`

Deprecated, use `fail_level` instead.

### `reviewdog_flags`

Optional. Additional reviewdog flags.

## Simple check example

```yml
name: dotenv
on: [pull_request]
jobs:
  dotenv-linter:
    name: runner / dotenv-linter
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - name: Run dotenv-linter
        uses: dotenv-linter/action-dotenv-linter@v3
        with:
          reporter: github-pr-review # Default is github-pr-check
          dotenv_linter_flags: --ignore-checks UnorderedKey
```

## Code suggestions example

```yml
name: dotenv
on: [pull_request]
jobs:
  dotenv-linter:
    name: runner / dotenv-linter
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - name: Run dotenv-linter with code suggestions
        uses: dotenv-linter/action-dotenv-linter@v3
        with:
          reporter: github-code-suggestions
```

## Sponsor

<p>
  <a href="https://evrone.com/?utm_source=action-dotenv-linter">
    <img src="https://www.mgrachev.com/assets/static/sponsored_by_evrone.svg?sanitize=true" 
      alt="Sponsored by Evrone">
  </a>
</p>

## License

[MIT](https://choosealicense.com/licenses/mit)
