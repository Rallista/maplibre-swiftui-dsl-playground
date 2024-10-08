# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Version 0.1.0 - 2024-09-21

This project has migrated from Stadia Maps to the MapLibre organization!
To celebrate, we're bumping the version and adding a CHANGELOG.

Xcode and GitHub normally handle these sorts of changes well,
but sometimes they don't.
So, you'll probably want to be proactive and change your URLs from
`https://github.com/stadiamaps/maplibre-swiftui-dsl-playground`
to `https://github.com/maplibre/swiftui-dsl`.

If you're building a plain Xcode project, it might actually be easier to remove the Swift Package
and all of its targets and then re-add with the URL.

Swift Package authors can simply update the URLs.
Note that the package name also changes with the repo name.

```swift
    .product(name: "MapLibreSwiftDSL", package: "swiftui-dsl"),
    .product(name: "MapLibreSwiftUI", package: "swiftui-dsl"),
```
