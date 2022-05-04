# Contributing Guidelines

## Submitting Issues

Before submitting an issue, check the [existing GitHub issues][1] to ensure it has not already been
reported. If no issue exists, follow one of the issue templates provided. Follow the instructions
left in the comments (delimited by `<!-- ... -->`).

## Pull Requests

Before submitting a PR, check the [issues][1] and [open PRs][2] to see whether it has already been
covered. Each PR should correspond to an issue; this may not be necessary for some PRs, but we
reserve the right to reject PRs on the basis that they were not first discussed in an issue.

When you create the PR, please follow the pull request template. We will reject PRs that do not
follow the instructions left in the comments of the template.

For any PR that adds new functionality, we expect documentation (inline and/or doc comments) as
necessary.

## Code Style

We aren't too strict about code style, as long as the formatting is reasonable. Code should follow
these guidelines:

 - Any lines that are added should not change if you re-indent them in Xcode (Ctrl-I by default). In
   other words, Xcode should consider the intendation to already be correct.
 - All lines should be no more than 100 characters if possible. Exceptions are allowed in certain
   situations  (e.g. a long string literal, or a URL in a comment); however, doc comments are not
   necessarily an exception. Doc comments may show up narrower in Xcode, but they do not in other
   editors such as GitHub or VS Code.
 - Try to avoid committing whitespace-only changes in functions or declarations the PR does not
   otherwise touch.
 - When in doubt, match the style of existing code.

[1]: https://github.com/Tiny-Home-Consulting/Dependiject/issues?q=is%3Aissue
[2]: https://github.com/Tiny-Home-Consulting/Dependiject/pulls
