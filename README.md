<br/>

<p align="center">
    <img src="Assets/logo.png" width="30%" alt="logo">
</p>

<h1 align="center">
    FlyoverKit
</h1>

<p align="center">
    A Swift Package to easily perform flyovers on a <a href="https://developer.apple.com/documentation/mapkit/mkmapview">MKMapView</a>.
</p>

<p align="center">
   <a href="https://swiftpackageindex.com/SvenTiigi/FlyoverKit">
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSvenTiigi%2FFlyoverKit%2Fbadge%3Ftype%3Dswift-versions" alt="Swift Version">
   </a>
   <a href="https://swiftpackageindex.com/SvenTiigi/FlyoverKit">
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FSvenTiigi%2FFlyoverKit%2Fbadge%3Ftype%3Dplatforms" alt="Platforms">
   </a>
   <br/>
   <a href="https://github.com/SvenTiigi/FlyoverKit/actions/workflows/build_and_test.yml">
       <img src="https://github.com/SvenTiigi/FlyoverKit/actions/workflows/build_and_test.yml/badge.svg" alt="Build and Test Status">
   </a>
   <a href="https://sventiigi.github.io/FlyoverKit/documentation/flyoverkit/">
       <img src="https://img.shields.io/badge/Documentation-DocC-blue" alt="Documentation">
   </a>
   <a href="https://twitter.com/SvenTiigi/">
      <img src="https://img.shields.io/badge/Twitter-@SvenTiigi-blue.svg?style=flat" alt="Twitter">
   </a>
</p>

<img align="right" width="307" src="Assets/example-app.png" alt="Example application">

```swift
import SwiftUI
import FlyoverKit

struct ContentView: View {

    var body: some View {
        FlyoverMap(
            latitude: 37.3348,
            longitude: -122.0090
        )
    }

}
```

## Features

- [x] Configurable flyovers on a MKMapView 🚁
- [x] Easily start, stop and resume flyovers ⚙️
- [x] Support for SwiftUI and UIKit 🧑‍🎨
- [x] Runs on iOS and tvOS 📱 📺

## Installation

### Swift Package Manager

To integrate using Apple's [Swift Package Manager](https://swift.org/package-manager/), add the following as a dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/SvenTiigi/FlyoverKit.git", from: "2.0.0")
]
```

Or navigate to your Xcode project then select `Swift Packages`, click the “+” icon and search for `FlyoverKit`.

## Example

Check out the example application to see FlyoverKit in action. Simply open the `Example/Example.xcodeproj` and run the "Example" scheme.

## Usage

### SwiftUI

When using SwiftUI a `FlyoverMap` can be used to render and control a flyover.

```swift
var body: some View {
    FlyoverMap(
        // Bool value if flyover is started or stopped
        isStarted: true,
        // The coordinate to perform the flyover on
        coordinate: CLLocationCoordinate2D(
            latitude: 37.8023,
            longitude: -122.4057
        ),
        configuration: Flyover.Configuration(
            // The animation curve
            animationCurve: .linear,
            // The altitude in meter
            altitude: 900,
            // The pitch in degree
            pitch: 45.0,
            // The heading
            heading: .incremented(by: 1.5)
        ),
        // The map type e.g. .standard, .satellite, .hybrid
        mapType: .standard
    )
}
```

### UIKit

```swift
let flyoverMapView = FlyoverMapView()

if flyoverMapView.isFlyoverStarted {
    // ...
}

flyoverMapView.startFlyover(
    at: CLLocationCoordinate2D(
        latitude: 37.8023,
        longitude: -122.4057
    ),
    configuration: .default
)

flyoverMapView.stopFlyover()

flyoverMapView.resumeFlyover()
```

### Flyover

A `Flyover` object represents the core object to start, stop and resume a flyover on an instance of `MKMapView`.

```swift
let flyover = Flyover(
    mapView: self.mapView
)
```

> Note: The provided MKMapView is always weakly referenced

## License

```
FlyoverKit
Copyright (c) 2022 Sven Tiigi sven.tiigi@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
