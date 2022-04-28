# Dependiject

![Swift: 5.4, 5.5, 5.6][1]
![License: MPL-2.0][2]
![Platforms: macOS, iOS, tvOS, watchOS][3]

Dependiject provides simple and flexible dependency injection for testability and inversion of
control in SwiftUI apps.

## Requirements

To use this library requires Xcode 12.5 / Swift 5.4 or later. Dependiject is supported for all
platforms that support SwiftUI.

To install the library with CocoaPods requires version 1.10.0 or later, but we recommend using
version 1.11.0 or later.

To view the documentation in-browser (see [Documentation][4] below) requires CocoaPods 1.11.3 and
NodeJS 12.0.0 or later, and expects yarn to be installed globally.

## Examples

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
