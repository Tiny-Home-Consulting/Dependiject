# Changelog

All notable changes to this project will be documented in this file. See [Keep a Changelog] for
formatting guidelines.

## Unreleased

### Changed

- `MultitypeService` no longer exposes the implementation type by default. It may still be exposed
  explicitly.
- `@Store` now publishes changes on `RunLoop.main` by default, rather than immediately.

### Added

- Examples for testing `AnyObservableObject` in both example projects.
- Added automated tests.
- Created a changelog, contributing guidelines, and issue templates.

## [0.1.0] - 2022-05-02

Initial release.

[Keep a Changelog]: https://keepachangelog.com/en/1.0.0/
[0.1.0]: https://github.com/Tiny-Home-Consulting/Dependiject/tree/0.1.0
