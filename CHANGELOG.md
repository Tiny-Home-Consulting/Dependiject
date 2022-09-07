# Changelog

All notable changes to this project will be documented in this file. See [Keep a Changelog] for
formatting guidelines.

## Unreleased

### Changed

- The documentation can be run on any port when hosted locally, rather than always using port 3000.
- `MultitypeService` no longer exposes the implementation type by default. It may still be exposed
  explicitly.
- `@Store` now publishes changes on `RunLoop.main` by default, rather than immediately.

### Added

- Added documentation for `@Store`.
- Examples for testing `AnyObservableObject` in both example projects.
- Added automated tests.
- Created a changelog, contributing guidelines, and issue templates.

## [0.1.0] - 2022-05-02

Initial release.

[Keep a Changelog]: https://keepachangelog.com/en
[0.1.0]: https://github.com/Tiny-Home-Consulting/Dependiject/tree/0.1.0
