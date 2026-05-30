# Cadence Shift

Cadence Shift is a SwiftUI app with iOS and watchOS targets.

## Project Structure

```text
CadenceShiftApp.xcodeproj        Xcode project to open and run
CadenceShiftApp/                 iOS app source
  CadenceShiftApp.swift          App entry point
  ContentView.swift              Main screen
  Preview Content/               SwiftUI preview-only assets
CadenceShiftWatchApp/            watchOS app source
  CadenceShiftWatchApp.swift     Watch app entry point
  WatchContentView.swift         Main watch screen
Shared/                          Code shared by iOS and watchOS
  AppInfo.swift                  Shared app metadata
IDEA.md                          Notes and product ideas
LICENSE                          License
```

## Run The App

Open the Xcode project:

```sh
open CadenceShiftApp.xcodeproj
```

In Xcode, choose the `CadenceShiftApp` scheme, select an iPhone simulator, then press `Command + R`.

To run the watch app, choose the `CadenceShiftWatchApp` scheme and select a watch simulator.

## Notes

This repository is an Xcode app project, not a Swift Package command-line executable. Use Xcode to run the iOS and watchOS UIs.
