# Changelog

All notable changes to this project will be documented in this file. See [Keep a Changelog] for
formatting guidelines.

## Unreleased

### Added

- Added a `setSynchronizer` method to `Factory`, and a corresponding `Synchronizer` protocol, for
  controlling how dependency resolution is synchronized.

### Changed

- Singleton registrations no longer hold onto the closure after the instance is created.

## [1.0.0] - 2022-12-13

### Removed

- Dropped support for CocoaPods &lt; 1.11.3.
- Dropped support for Swift &lt; 5.5 (Xcode &lt; 13.2).

### Fixed

- Hosting the documentation locally no longer emits a warning about build order.
- Extraneous arguments in Service callbacks will now be properly diagnosed.
- The `@Store` property wrapper now follows Swift's concurrency rules.

### Added

- MultitypeService now supports named dependencies.
- `Resolver` now has a new requirement, `resolveAll(_:)`, which gives a mapping of name -> instance
  for all dependencies of a given type.
- The factory now has a `clearDependencies()` method intended for testing.
- Singletons which depend on weak services now trigger an assertion failure by default.

### Changed

- Switching over `Scope` now requires a `default:` branch.
- `MultitypeService.Iterator` is now an alias for `AnyIterator<Registration>`, not
  `IndexingIterator<[Registration]>`.
- The factory's options cannot be accessed directly; instead, use the static methods `getOptions()`
  and `updateOptions(mutation:)`.
- `@Store` now publishes changes on `DispatchQueue.main` by default, rather than `RunLoop.main`.
- The default options are now reflected in the initializer for `ResolutionOptions`.
- The test and documentation scripts now use `xcpretty` to clean up `xcodebuild` output.
- The `name` argument to `Service.init` is now a labeled argument, to better match `resolve`.

## [0.3.0] - 2022-10-03

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
[0.3.0]: https://github.com/Tiny-Home-Consulting/Dependiject/tree/0.3.0
[1.0.0]: https://github.com/Tiny-Home-Consulting/Dependiject/tree/1.0.0
