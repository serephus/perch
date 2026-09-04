# Perch

A simple GitHub Action that fails when a feature branch is no longer based on the current tip of its base branch.

This is useful for pull request workflows where a feature branch must start from the base branch and stay linear as the base branch moves forward.

## How it works

For a pull request branch to pass, the current tip of the base branch must be an ancestor of the feature branch tip.

If the base branch has moved and the feature branch has not been rebased onto that new tip, the action fails.

## Usage

```yaml
name: perch

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  check-branch-base:
    runs-on: ubuntu-latest
    steps:
      - name: Check that the PR branch is based on the latest base branch tip
        uses: serephus/perch@v1
        with:
          feature: ${{ github.head_ref }}
          base: ${{ github.base_ref }}
```

## Inputs

- `feature`: Feature branch name. Required.
- `base`: Base branch name. Optional. Defaults to the repository default branch.
- `token`: GitHub token used to fetch branch refs. Optional. Defaults to `github.token`.

## Failure case

If `main` advances from `A` to `B`, and your feature branch still starts from `A`, the action fails until the feature branch is rebased so `B` is an ancestor of the feature branch tip.

## License

This project is licensed under the GLWTPL (Good Luck With That Public License). See the `LICENSE` file for more details.
