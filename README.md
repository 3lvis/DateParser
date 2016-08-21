![logo](https://raw.githubusercontent.com/3lvis/DateParser/master/Resources/logo-v1.png)

[![Version](https://img.shields.io/cocoapods/v/DateParser.svg?style=flat)](https://cocoapods.org/pods/DateParser)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/3lvis/DateParser)
![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20OS%20X%20%7C%20watchOS%20%7C%20tvOS%20-lightgrey.svg)
[![License](https://img.shields.io/cocoapods/l/DateParser.svg?style=flat)](https://cocoapods.org/pods/DATAStack)

Simple ISO 8601 and Unix timestamp Swift date parser.

## Usage

```swift
// ISO 8601
let isoDate = NSDate(fromDateString:"2015-06-23T14:40:08.000+02:00")

// Unix Timestamp
let timestampDate = NSDate(fromDateString:"1441843200")

// Returns DateType.ISO8601  
let isoDateType = "2014-01-02T00:00:00.007450+00:00".dateType()

// Returns DateType.UnixTimestamp
let timestampDateType = "1441843200000000".dateType()
```

## Supported Formats

```
2014-01-02
2016-01-09T00:00:00
2014-03-30T09:13:00Z
2016-01-09T00:00:00.00
2015-06-23T19:04:19.911Z
2014-01-01T00:00:00+00:00
2015-09-10T00:00:00.184968Z
2015-09-10T00:00:00.116+0000
2015-06-23T14:40:08.000+02:00
2014-01-02T00:00:00.000000+00:00
```

## Installation

**DateParser** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DateParser'
```

**DateParser** is also available through [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Cartfile:

```ruby
github "3lvis/DateParser"
```

## License

**DateParser** is available under the MIT license. See the LICENSE file for more info.

## Author

Elvis Nuñez, [@3lvis](https://twitter.com/3lvis)
