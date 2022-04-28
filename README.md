# Dependiject

![Swift: 5.4, 5.5, 5.6][1]
![License: MPL-2.0][2]
![Platforms: macOS, iOS, tvOS, watchOS][3]

Dependiject provides simple and flexible dependency injection for testability and inversion of
control in SwiftUI apps.

## Overview

There are many Swift dependency injection libraries out there. However, Dependiject aimed for
maximum utility and flexibility in a modern SwiftUI app.

### The Problem

SwinjectStoryboard is specially designed to work with AppKit and UIKit applications that use
storyboards for their UI. It's a great library, but the fact that it requires a storyboard limits
its usefulness in a SwiftUI application.

Property wrapper injection is easy to write and easy to find resources on, but it's quite
restrictive -- you can't mark a variable as both `@Injected` and `@StateObject`.

Even SwiftUI's builtins, like `@EnvironmentObject`, are limited and can be dangerous: they prevent
the use of protocols as abstractions and require all dependencies to be created eagerly on app
launch.

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
            stateAccessor: r.getInstance()!
        )
    }
    
    Service(.weak, AnotherViewModelProtocol.self) { r in
        AnotherViewModel(
            networkManager: r.getInstance()!,
            stateUpdater: r.getInstance()!
        )
    }
}

struct SomeView: View {
    // Use the singleton Factory instance to get what you registered:
    @Store var viewModel = Factory.shared.getInstance(AViewModelProtocol.self)!
    
    var body: some View {
        // ...
    }
}
```

## Requirements

To use this library requires Xcode 12.5 / Swift 5.4 or later. Dependiject is supported for all
platforms that support SwiftUI.

To install the library with CocoaPods requires version 1.10.0 or later, but we recommend using
version 1.11.0 or later.

To view the documentation in-browser (see [Documentation][4] below) requires CocoaPods 1.11.3 and
NodeJS 12.0.0 or later, and expects yarn to be installed globally.

## Example Projects

There are two examples provided: 
- an [iOS 13 project][5] that uses SwiftUI for the Views but still requires the UIKit lifecycle;
- an [iOS 14+ project][6] that can use the SwiftUI lifecycle.

## Documentation

All documentation is provided via inline doc comments that can be parsed by Xcode.

To view the documentation in a browser, run `./dochost.sh`.

## License

Dependiject is released under the MPL-2.0 license. See [LICENSE][7] for details.

[1]: https://img.shields.io/badge/Swift-5.4_5.5_5.6-orange
[2]: https://img.shields.io/badge/license-MPL--2.0-blue
[3]: https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS-yellowgreen
[4]: #documentation
[5]: ./iOS%2013%20Example/
[6]: ./iOS%2014%20Example/
[7]: ./LICENSE
