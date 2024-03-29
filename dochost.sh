#!/bin/sh

#  dochost.sh
#  Dependiject
#
#  Created by William Baker on 04/27/22.
#  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
#

set -eo pipefail
cd "iOS 13 Example"
pod install
cd ..
which xcpretty &>/dev/null || bundle install
xcodebuild docbuild | xcpretty
cd docserver
yarn
node index.js
