# Dependiject

![Swift Version][1]
![License][2]
![Supported Platforms][3]
![Version][8]

Dependiject provides simple, flexible, and thread-safe dependency injection for testability and
inversion of control in SwiftUI apps.

## Overview

There are many Swift dependency injection libraries out there. However, Dependiject aimed for
maximum utility and flexibility in a modern SwiftUI app.

### The Problem

We wanted simple dependency injection for SwiftUI, but were unable to find an existing solution that
fully met our needs.

Some existing libraries require the app to create an instance of the dependency container, which
must then be passed from view to view. This is less than ideal because it violates inversion of
control.

Property wrapper injection is easy to write and easy to find resources on, but it's somewhat
restrictive -- you can't mark a variable as both `@Injected` and `@StateObject`.

SwiftUI's built-in property wrappers `@StateObject` and `@EnvironmentObject` prevent the use of
protocols, making it difficult to separate the interface of a dependency from its implementation.

### Our Solution

Dependiject is an extendible library which loads its dependencies using configurable scopes.
Singletons are clearly marked as such, and it's straightforward to expose one under multiple
protocols. We provide the property wrapper `@Store` to work around the problems with `@StateObject`
and `@EnvironmentObject`, leading to better type safety and inversion of control.

Three dependency "scopes" come with the library -- singleton, weak, and transient -- and it's easy
to create your own service type when those provided aren't sufficient.

### Code Sample

```swift
// Inside your App's startup code, provide a register block to add your dependencies:
Factory.register {
    // Services can be exposed under just one protocol...
    Service(.singleton, NetworkManagerProtocol.self) { _ in
        NetworkManager()
    }
    // ...or under multiple at once:
    MultitypeService(exposedAs: [StateUpdater.self, StateAccessor.self]) { _ in
        StateManager()
    }
    
    // Type inference makes resolving further dependencies even easier:
    Service(.weak, AViewModelProtocol.self) { r in
        AViewModel(
            stateAccessor: r.resolve()
        )
    }
    
    Service(.weak, AnotherViewModelProtocol.self) { r in
        AnotherViewModel(
            networkManager: r.resolve(),
            stateUpdater: r.resolve()
        )
    }
}

struct SomeView: View {
    // Use the singleton Factory instance to get what you registered:
    @Store var viewModel = Factory.shared.resolve(AViewModelProtocol.self)
    
    var body: some View {
        // ...
    }
}
```

## Requirements

To use this library requires Xcode 13.2 / Swift 5.5 or later. Dependiject is supported for all
platforms that support SwiftUI.

To install the library with CocoaPods requires version 1.10.0 or later, but we recommend using
version 1.11.0 or later.

To run the tests from the command line (see [Automated Tests][9] below) requires CocoaPods 1.11.3
and NodeJS 6 or later.

To host the documentation locally (see [Documentation][4] below) requires CocoaPods 1.11.3 and
NodeJS 12 or later, and expects yarn to be installed globally.

## Installation

### CocoaPods

Add the following line to your Podfile:

```ruby
pod 'Dependiject', '~> 0.3'
```

### Swift Package Manager

Add the following entry to the `dependencies` array in your Package.swift:

```swift
.package(
    url: "https://github.com/Tiny-Home-Consulting/Dependiject.git",
    .upToNextMajor(from: "0.3.0")
)
```

## Example Projects

There are two examples provided: 
- an [iOS 13 project][5] that uses SwiftUI for the Views but still requires the UIKit lifecycle;
- an [iOS 14+ project][6] that can use the SwiftUI lifecycle.

## Documentation

All documentation is provided via inline doc comments that can be parsed by Xcode.

The documentation is hosted at <https://dependiject.tinyhomeconsultingllc.com/documentation/>. To
host it locally, run `./dochost.sh`. By default, it will search for an available port to open on,
but the port can be set by the environment variable `DOC_PORT`. For example, to run it on port 3000,
type:  
`DOC_PORT=3000 ./dochost.sh`  
Attempting to run on port 0 will result in the default behavior.

## Automated Tests

To run the automated tests, simply run the command `./runtests.sh` in the terminal. The tests can
also be run in Xcode.

## License

Dependiject is released under the MPL-2.0 license. See [LICENSE][7] for details.

[1]: https://img.shields.io/badge/swift-~%3E%205.5-orange
[2]: https://img.shields.io/cocoapods/l/Dependiject?color=blue
[3]: https://img.shields.io/cocoapods/p/Dependiject?color=yellowgreen
[4]: #documentation
[5]: ./iOS%2013%20Example/
[6]: ./iOS%2014%20Example/
[7]: ./LICENSE
[8]: https://img.shields.io/cocoapods/v/Dependiject
[9]: #automated-tests
