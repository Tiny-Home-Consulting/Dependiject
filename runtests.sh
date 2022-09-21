#!/bin/zsh

#  dochost.sh
#  Dependiject
#
#  Created by William Baker on 09/20/22.
#  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
#

# Get the simulator list and pick a device.
# The xcrun command gives a formatted list of simulators, with different OS's separated by headings
# that start with '--'. The grep command removes these headings.
# Since simulators are listed in order from oldest to newest, picking the last one (with tail) will
# ensure that the device is a new enough iOS to run the example projects.
# Finally, parse out the device's id (a capitalized, hyphenated UUID) using a regex.
device=$(xcrun simctl list devices iPhone available | grep -v -- -- | tail -n 1)
deviceId=$(node -p "/[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}/u.exec('$device')[0]")

set -e

swift test

cd "iOS 13 Example"
pod install
xcodebuild -workspace Dependiject.xcworkspace -scheme Dependiject_Example -destination \
    "id=$deviceId" test

cd "../iOS 14 Example"
pod install
xcodebuild -workspace Dependiject_Example.xcworkspace -scheme Dependiject_Example -destination \
    "id=$deviceId" test
