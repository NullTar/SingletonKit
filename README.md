# Singleton Macro

A Swift Macro to generate singleton pattern automatically, support custom `init`.

## Features
- Auto generate static `shared` instance
- Support custom `init`
- Simple annotation, zero boilerplate code

## Installation

### Swift Package Manager
Add this package to your `Package.swift`:

dependencies: [
    .package(url: "https://github.com/NullTar/SingletonKit.git")
]

Or add it in Xcode:
`File > Add Package Dependencies`
Paste repo url: `https://github.com/NullTar/SingletonKit.git`

```swift
import Singleton

@Singleton
final class SingletonClass {
    // You can write your custom init here
    private init() {
        print("custom singleton init")
    }
    
    func hello() {
        print("Hello from singleton")
    }
}

// Access instance
SingletonClass.shared.hello()

```
> Tip: It is strongly recommended to mark the class as `final` to avoid inheritance issues of singleton.

## Generated Code

The macro will roughly expand to the following code:

```
final class SingletonClass {
    static let shared = SingletonClass()
    
    private init() {
        print("custom singleton init")
    }
    
    func hello() {
        print("Hello from singleton")
    }
}
```
## Notes

1. The macro will **not overwrite** your existing `private init`, it supports custom initialization logic.
2. Please keep `init` as `private` to prevent external instantiation.
