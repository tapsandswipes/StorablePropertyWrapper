# StorablePropertyWrapper

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)]() [![Language](http://img.shields.io/badge/language-swift-orange.svg?style=flat)](https://developer.apple.com/swift) 
[![Swift Package Manager](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)]()

A swift property wrapper for type safe storing objects in Key-Value stores. Perfecctly tailored for UserDefaults and usable for SwiftUI bindings


## Usage

Define your storable properties as usual and prepend them with the @Storable keyword. As any other property wrapper it supports static and non static properties.

```swift
class MyStorableValuesContainer {

    @Storable(key: "myStorableValueStringKey", default: "Hello")
    static var myStorableValueString: String

    @Storable(key: "myStorableValueBoolKey", default: false)
    static var myStorableBoolValue: Bool

    @Storable(key: "myStorableValueDateKey", default: nil)
    var myStorableDateValue: Date?

}
```

Many standard types are supported by default and also containers of those types are supported, like arrays and dictionaries. Enums with raw values of those standard types are also supported.

If you want to store types that support `Codabe`, you only need to tag your type with support to  `StorableCodableValue` protocol and the property wraper takes care of all the coding and decoding.

```swift
struct MyStruct: Codable {
    var name: String
    var date: Date
}

extension MyStruct: StorableCodableValue {}

…

class MyCustomStoreContainer {

    @Storable(key: "myStorableValueKey", default: nil)
    var myStruct: MyStruct?

}
```

## Custom Key-Value store

@Storable is not only usable with UserDefaults, it's store agnostic and you can add support for other Key-Value stores. Just implement the protocol `KeyStore` in you Key-Value store and add the store instence in the @Storable construstor  like this:

```swift
extension MyKeyValueStore: KeyStore {
... Implement the KeyStore protocol required methods ...
}

let store: MyKeyValueStore = MyKeyValueStore()

class MyCustomStoreContainer {

    @Storable(key: "myStorableValueStringKey", default: "Hello", store: store)
    var myStorableValueString: String
    
    …
}
```

## Bonus functionality

If you want to delete the value stored in the Key-Value store, @Storeable allow access to the wrapped value through `${property}` calling the method  `remove()` like this:

```swift

class MyCustomStoreContainer {

    @Storable(key: "myStorableValueStringKey", default: "Hello", store: store)
    static var myStorableValueString: String
    
    …
}

MyCustomStoreContainer.$myStorableValueString.remove()
```

@Storeable also send notifications for will/did change specific for each property so you can react to changes of all individual properties. 

```swift

let token = NotificationCenter.default.addObserver( forName: MyCustomStoreContainer.$myStorableValueString.willChangeNotification, object: nil, queue: nil ) { notification in
  // React to will change 
}

let token = NotificationCenter.default.addObserver( forName: MyCustomStoreContainer.$myStorableValueString.didChangeNotification, object: nil, queue: nil ) { notification in
  // React to did change 
}

```

## Installation

You can use the [Swift Package Manager](https://github.com/apple/swift-package-manager) by declaring **StorablePropertyWrapper** as a dependency in your `Package.swift` file:

```swift
.package(url: "https://github.com/tapsandswipes/StorablePropertyWrapper", from: "1.0.0")
```

*For more information, see [the Swift Package Manager documentation](https://github.com/apple/swift-package-manager/tree/master/Documentation).*


## Contact

- [Personal website](http://tapsandswipes.com)
- [GitHub](http://github.com/tapsandswipes)
- [Twitter](http://twitter.com/acvivo)
- [LinkedIn](http://www.linkedin.com/in/acvivo)
- [Email](mailto:antonio@tapsandswipes.com)

If you use/enjoy StorablePropertyWrapper, let me know!


## License

### MIT License

Copyright (c) 2020 Antonio Cabezuelo Vivo

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
