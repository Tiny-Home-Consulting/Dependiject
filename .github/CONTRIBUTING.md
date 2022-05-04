# Contributing Guidelines

## Submitting Issues

Before submitting an issue, check the [existing GitHub issues][1] to ensure it has not already been
reported. If no issue exists, follow one of the issue templates provided. Read the comments in the
templates (delimited by `<!-- ... -->`) and follow the instructions.

## Pull Requests

Before submitting a PR, check the [issues][1] and [open PRs][2] to see whether it has already been
covered. Each PR should correspond to an issue; this may not be necessary for some PRs, but we
reserve the right to reject PRs on the basis that they were not first discussed in an issue.

When you create the PR, please follow the pull request template. We will reject PRs that do not
follow the instructions left in the comments of the template.

Any PRs that add new functionality are expected to document it with inline and/or doc comments as
necessary.

## Code Style

Our code style isn't too strict, as long as the formatting is reasonable. Code should follow these
guidelines:

 - Any lines that are added should not change if you select them in Xcode and hit Ctrl-I (autofix
   indentation). In other words, Xcode should consider the intendation to already be correct.
 - All lines should be no more than 100 characters if possible. Exceptions are allowed in certain
   situations  (e.g. a long string literal, or a URL in a comment); however, doc comments are not
   necessarily an exception. Doc comments may show up narrower in Xcode, but they do not in other
   editors such as in GitHub.
 - Try to avoid committing whitespace-only changes in functions or declarations the PR does not
   otherwise touch.
 - When in doubt, match the style of existing code.

[1]: https://github.com/Tiny-Home-Consulting/Dependiject/issues?q=is%3Aissue
[2]: https://github.com/Tiny-Home-Consulting/Dependiject/pulls
