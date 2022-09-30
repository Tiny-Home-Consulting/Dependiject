# Changelog

All notable changes to this project will be documented in this file. See [Keep a Changelog] for
formatting guidelines.

## Unreleased

### Fixed

- The factory is now thread-safe: its functions may be simultaneously called on different threads.
- The example projects now look the same when run on iOS 16 as on earlier versions.

### Added

- Added a way to register existing instances as dependencies.
- Added a script to run all tests, including for the example projects.
- Added automated tests for `@Store`.

## [0.2.0] - 2022-09-14

### Changed

- The documentation can be run on any port when hosted locally, rather than always using port 3000.
- `MultitypeService` no longer exposes the implementation type by default. It may still be exposed
  explicitly.
- `@Store` now publishes changes on `RunLoop.main` by default, rather than immediately.

### Added

- The factory can now check for circular dependencies. This is enabled by default in debug builds.
- The podspec now includes a documentation URL.
- Added documentation for `@Store`.
- Examples for testing `AnyObservableObject` in both example projects.
- Added automated tests.
- Created a changelog, contributing guidelines, and issue templates.

## [0.1.0] - 2022-05-02

Initial release.

[Keep a Changelog]: https://keepachangelog.com/en
[0.1.0]: https://github.com/Tiny-Home-Consulting/Dependiject/tree/0.1.0
[0.2.0]: https://github.com/Tiny-Home-Consulting/Dependiject/tree/0.2.0
