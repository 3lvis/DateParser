![logo](https://raw.githubusercontent.com/SyncDB/DateParser/master/Resources/logo-v1.png)

<div align = "center">
  <a href="https://cocoapods.org/pods/DateParser">
    <img src="https://img.shields.io/cocoapods/v/DateParser.svg?style=flat" />
  </a>
  <a href="https://github.com/SyncDB/DateParser">
    <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" />
  </a>
  <a href="https://github.com/SyncDB/DateParser#installation">
    <img src="https://img.shields.io/badge/compatible-swift%203.0%20-orange.svg" />
  </a>
</div>

<div align = "center">
  <a href="https://cocoapods.org/pods/DateParser" target="blank">
    <img src="https://img.shields.io/cocoapods/p/DateParser.svg?style=flat" />
  </a>
  <a href="https://cocoapods.org/pods/DateParser" target="blank">
    <img src="https://img.shields.io/cocoapods/l/DateParser.svg?style=flat" />
  </a>
  <a href="https://gitter.im/SyncDB/DateParser">
    <img src="https://img.shields.io/gitter/room/nwjs/nw.js.svg" />
  </a>
  <br>
  <br>
</div>

Simple ISO 8601 and Unix timestamp Swift date parser.

## Usage

```swift
// ISO 8601
let isoDate = try Date(dateString:"2015-06-23T14:40:08.000+02:00")

// Unix Timestamp
let timestampDate = try Date(unixTimestampString:"1441843200")

// Returns DateType.ISO8601  
let isoDateType = "2014-01-02T00:00:00.007450+00:00".dateType

// Returns DateType.UnixTimestamp
let timestampDateType = "1441843200000000".dateType
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
github "SyncDB/DateParser"
```

## License

**DateParser** is available under the MIT license. See the LICENSE file for more info.

## Author

Elvis Nuñez, [@3lvis](https://twitter.com/3lvis)
