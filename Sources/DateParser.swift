import Foundation

struct DateParser {
    static var noTimestampFormat = "YYYY-MM-DD"
    static var timestamp = "T00:00:00+00:00"
}

public enum DateType {
    case iso8601, unixTimestamp
}

public extension Date {
    public init?(dateString: String) {
        let dateType = dateString.dateType()
        switch dateType {
        case .iso8601:
            self.init(iso8601String: dateString)
            break
        case .unixTimestamp:
            self.init(unixTimestampString: dateString)
            break
        }
    }

    public init?(iso8601String: String) {
        if (iso8601String as NSString) == NSNull() {
            return nil
        } else {
            var dateString = iso8601String
            if dateString.characters.count == DateParser.noTimestampFormat.characters.count {
                dateString.append(DateParser.timestamp)
            }

            if iso8601String.isEmpty {
                return nil
            }

            let originalLength = dateString.characters.count
            let originalString = dateString
            var currentString = ""
            var hasFullTimeZone = false
            var hasNormalizedTimeZone = false
            var hasCentiseconds = false
            var hasMiliseconds = false
            var hasMicroseconds = false

            // ----
            // In general lines, if a Z is found, then the Z is removed since all dates operate
            // in GMT as a base, unless they have timezone, and Z is the GMT indicator.
            //
            // If +00:00 or any number after + is found, then it means that the date has a timezone.
            // This means that `hasTimezone` will have to be set to true, and since all timezones go to
            // the end of the date, then they will be parsed at the end of the process and appended back
            // to the parsed date.
            //
            // If after the date theres `.` and a number `2014-03-30T09:13:00.XXX` the `XXX` is the milisecond
            // then `hasMiliseconds` will be set to true. The same goes for `XX` decisecond (hasCentiseconds set to true).
            // and microseconds `XXXXXX` (hasMicroseconds set yo true).
            //
            // If your date format is not supported, then you'll get "Signal Sigabrt". Just ask your format to be included.
            // ----

            switch originalLength {
            case 19:
                // Copy all the date
                // Current date: 2014-03-30T09:13:00
                // Will become:  2014-03-30T09:13:00
                // Unit test A
                currentString = originalString
            case 20:
                // Copy all the date excluding the Z.
                // Current date: 2014-03-30T09:13:00Z
                // Will become:  2014-03-30T09:13:00
                // Unit test B
                let timeZoneIndicatorIndex = originalString.index(originalString.endIndex, offsetBy: -1)
                if originalString[timeZoneIndicatorIndex] == "Z" {
                    currentString = originalString.substring(to: timeZoneIndicatorIndex)
                }
            case 22:
                // Copy all the date excluding the miliseconds.
                // Current date: 2016-01-09T00:00:00.00
                // Will become:  2016-01-09T00:00:00
                // Unit test C
                let evaluatedDate = "2016-01-09T00:00:00"
                let timeZoneColonIndex = originalString.index(originalString.startIndex, offsetBy: evaluatedDate.characters.count)
                if originalString[timeZoneColonIndex] == "." {
                    let targetDate = "2014-01-01T00:00:00"
                    let baseDateIndex = originalString.index(originalString.startIndex, offsetBy: targetDate.characters.count)
                    currentString = originalString.substring(to: baseDateIndex)
                    hasCentiseconds = true
                }
            case 24:
                // Copy all the date excluding the miliseconds and the Z.
                // Current date: 2014-03-30T09:13:00.000Z
                // Will become:  2014-03-30T09:13:00
                // Unit test D
                let gmtIndicatorIndex = originalString.index(originalString.endIndex, offsetBy: -1)
                if originalString[gmtIndicatorIndex] == "Z" {
                    let targetDate = "2014-01-01T00:00:00"
                    let baseDateIndex = originalString.index(originalString.startIndex, offsetBy: targetDate.characters.count)
                    currentString = originalString.substring(to: baseDateIndex)
                    hasMiliseconds = true
                }
            case 25:
                // Copy all the date excluding the timezone also set `hasTimezone` to true.
                // Current date: 2014-01-01T00:00:00+00:00
                // Will become:  2014-01-01T00:00:00
                // Unit test E and F
                let evaluatedDate = "2014-01-01T00:00:00+00"
                let timeZoneColonIndex = originalString.index(originalString.startIndex, offsetBy: evaluatedDate.characters.count)
                if originalString[timeZoneColonIndex] == ":" {
                    let targetDate = "2014-01-01T00:00:00"
                    let baseDateIndex = originalString.index(originalString.startIndex, offsetBy: targetDate.characters.count)
                    currentString = originalString.substring(to: baseDateIndex)
                    hasFullTimeZone = true
                }
            case 27:
                // Copy all the date excluding the microseconds and the Z.
                // Current date: 2015-09-10T00:00:00.184968Z
                // Will become:  2015-09-10T00:00:00
                // Unit test G
                let evaluatedDate = "2015-09-10T00:00:00"
                let timeZoneColonIndex = originalString.index(originalString.startIndex, offsetBy: evaluatedDate.characters.count)
                let gmtIndicatorIndex = originalString.index(originalString.endIndex, offsetBy: -1)
                if originalString[timeZoneColonIndex] == "." && originalString[gmtIndicatorIndex] == "Z" {
                    let targetDate = "2014-01-01T00:00:00"
                    let baseDateIndex = originalString.index(originalString.startIndex, offsetBy: targetDate.characters.count)
                    currentString = originalString.substring(to: baseDateIndex)
                    hasMicroseconds = true
                }
            case 28:
                // Copy all the date excluding the microseconds and the timezone.
                // Current date: 2015-09-10T13:47:21.116+0000
                // Will become:  2015-09-10T13:47:21
                // Unit test H
                let evaluatedDate = "2015-09-10T13:47:21.116"
                let timeZoneColonIndex = originalString.index(originalString.startIndex, offsetBy: evaluatedDate.characters.count)
                if originalString[timeZoneColonIndex] == "+" {
                    let targetDate = "2014-01-01T00:00:00"
                    let baseDateIndex = originalString.index(originalString.startIndex, offsetBy: targetDate.characters.count)
                    currentString = originalString.substring(to: baseDateIndex)
                    hasMiliseconds = true
                    hasNormalizedTimeZone = true
                }
            case 29:
                // Copy all the date excluding the miliseconds and the timezone also set `hasTimezone` to true.
                // Current date: 2015-06-23T12:40:08.000+02:00
                // Will become:  2015-06-23T12:40:08
                // Unit test I
                let evaluatedDate = "2015-06-23T12:40:08.000+02"
                let timeZoneColonIndex = originalString.index(originalString.startIndex, offsetBy: evaluatedDate.characters.count)
                if originalString[timeZoneColonIndex] == ":" {
                    let targetDate = "2015-06-23T12:40:08"
                    let baseDateIndex = originalString.index(originalString.startIndex, offsetBy: targetDate.characters.count)
                    currentString = originalString.substring(to: baseDateIndex)
                    hasFullTimeZone = true
                    hasMiliseconds = true
                }
            case 32:
                // Copy all the date excluding the microseconds and the timezone also set `hasTimezone` to true.
                // Current date: 2015-08-23T09:29:30.007450+00:00
                // Will become:  2015-08-23T09:29:30
                // Unit test J
                let evaluatedDate = "2015-08-23T09:29:30.007450+00"
                let timeZoneColonIndex = originalString.index(originalString.startIndex, offsetBy: evaluatedDate.characters.count)
                if originalString[timeZoneColonIndex] == ":" {
                    let targetDate = "2015-06-23T12:40:08"
                    let baseDateIndex = originalString.index(originalString.startIndex, offsetBy: targetDate.characters.count)
                    currentString = originalString.substring(to: baseDateIndex)
                    hasFullTimeZone = true
                    hasMicroseconds = true
                }
            default:
                fatalError("Your date format \(originalString) is not supported, please file a bug report asking it to be added.")
                break
            }

            // Timezone
            let currentLength = currentString.characters.count
            if hasFullTimeZone {
                // Convert time zone from hours and minutes and append it to the current string.
                // Original date: 2015-06-23T14:40:08.000+02:00
                // Current date:  2015-06-23T14:40:08
                // Will become:   2015-06-23T14:40:08+0200
                var timeZone: String {
                    let endIndex = originalString.index(originalString.endIndex, offsetBy: -"+02:00".characters.count)
                    let fullTimeZone = originalString.substring(from: endIndex)

                    return fullTimeZone.replacingOccurrences(of: ":", with: "")
                }
                currentString = currentString.appending(timeZone)
            } else if hasNormalizedTimeZone {
                // Trim time zone and append it to the current string.
                // Original date: 2015-06-23T14:40:08.000+0200
                // Current date:  2015-06-23T14:40:08
                // Will become:   2015-06-23T14:40:08+0200
                var timeZone: String {
                    let endIndex = originalString.index(originalString.endIndex, offsetBy: -"+0200".characters.count)

                    return originalString.substring(from: endIndex)
                }
                currentString = currentString.appending(timeZone)
            } else {
                // Add GMT timezone to the end of the string
                // Current date: 2015-09-10T00:00:00
                // Will become:  2015-09-10T00:00:00+0000
                currentString = currentString.appending("+0000")
            }

            // Parse the formatted date using `strptime`.
            // %F: Equivalent to %Y-%m-%d, the ISO 8601 date format
            //  T: The date, time separator
            // %T: Equivalent to %H:%M:%S
            // %z: An RFC-822/ISO 8601 standard timezone specification
            var tmc: tm = tm(tm_sec: 0, tm_min: 0, tm_hour: 0, tm_mday: 0, tm_mon: 0, tm_year: 0, tm_wday: 0, tm_yday: 0, tm_isdst: 0, tm_gmtoff: 0, tm_zone: nil)
            if strptime(UnsafeMutablePointer(mutating: currentString), "%FT%T%z", &tmc) == nil {
                return nil
            }

            var time = Double(mktime(&tmc))

            if hasCentiseconds || hasMiliseconds || hasMicroseconds {
                let trimmedDate = dateString.substring(from: "2015-09-10T00:00:00.".endIndex)

                if hasCentiseconds {
                    let centisecondsString = trimmedDate.substring(to: "00".endIndex)
                    if let doubleString = Double(centisecondsString) {
                        let centiseconds = doubleString / 100.0
                        time += centiseconds
                    }
                }

                if hasMiliseconds {
                    let milisecondsString = trimmedDate.substring(to: "000".endIndex)
                    if let doubleString = Double(milisecondsString) {
                        let miliseconds = doubleString / 1000.0
                        time += miliseconds
                    }
                }

                if hasMicroseconds {
                    let microsecondsString = trimmedDate.substring(to: "000000".endIndex)
                    if let doubleString = Double(microsecondsString) {
                        let microseconds = doubleString / 1000000.0
                        time += microseconds
                    }
                }
            }

            self.init(timeIntervalSince1970: time)
        }
    }

    public init(unixTimestampNumber: NSNumber) {
        self.init(unixTimestampString: unixTimestampNumber.stringValue)
    }

    public init(unixTimestampString: String) {
        var parsedString = unixTimestampString
        let validUnixTimestamp = "1441843200"
        let validLength = validUnixTimestamp.characters.count
        if unixTimestampString.characters.count > validLength {
            parsedString = unixTimestampString.substring(to: validUnixTimestamp.endIndex)
        }

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let unixTimestampNumber = numberFormatter.number(from: parsedString) {
            self.init(timeIntervalSince1970: unixTimestampNumber.doubleValue)
        } else {
            fatalError("Invalid unix timestamp \(unixTimestampString), please file an issue to get support for your date type")
        }
    }
}

public extension String {
    public func dateType() -> DateType {
        if self.contains("-") {
            return .iso8601
        } else {
            return .unixTimestamp
        }
    }
}
