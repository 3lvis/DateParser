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
            if iso8601String.characters.count == DateParser.noTimestampFormat.characters.count {
                dateString.append(DateParser.timestamp)
            }

            if var originalString = dateString.cString(using: String.Encoding.utf8) {
                let originalLength = Int(strlen(originalString))
                if originalLength == 0 {
                    return nil
                }

                let currentString = "".cString(using: String.Encoding.utf8)!
                var hasTimezone = false
                var hasCentiseconds = false
                var hasMiliseconds = false
                var hasMicroseconds = false

                // ----
                // In general lines, if a Z is found, then the Z is removed since all dates operate
                // in GMT as a base, unless they have timezone, and Z is the GMT indicator.
                //
                // If +00:00 or any number after + is found, then it means that the date has a timezone.
                // This means that `hasTimezone` will have to be set to YES, and since all timezones go to
                // the end of the date, then they will be parsed at the end of the process and appended back
                // to the parsed date.
                //
                // If after the date theres `.` and a number `2014-03-30T09:13:00.XXX` the `XXX` is the milisecond
                // then `hasMiliseconds` will be set to YES. The same goes for `XX` decisecond (hasCentiseconds set to YES).
                // and microseconds `XXXXXX` (hasMicroseconds set yo YES).
                //
                // If your date format is not supported, then you'll get "Signal Sigabrt". Just ask your format to be included.
                // ----

                /*
                let utf8 = [originalString[originalLength - 1]]
                utf8.withUnsafeBufferPointer { ptr in
                }
                */

                switch originalLength {
                case 20:
                    // Copy all the date excluding the Z.
                    // Current date: 2014-03-30T09:13:00Z
                    // Will become:  2014-03-30T09:13:00
                    // Unit test H
                    let utf8 = [originalString[originalLength - 1]]
                    utf8.withUnsafeBufferPointer { pointer in
                        if String(validatingUTF8: pointer.baseAddress!) == "Z" {
                            strncpy(UnsafeMutablePointer(mutating: currentString), originalString, originalLength - 1)
                        }
                    }
                    break
                case 29:
                    // Copy all the date excluding the miliseconds and the timezone also set `hasTimezone` to YES.
                    // Current date: 2015-06-23T12:40:08.000+02:00
                    // Will become:  2015-06-23T12:40:08
                    // Unit test A
                    let utf8 = [originalString[26]]
                    utf8.withUnsafeBufferPointer { pointer in
                        if String(validatingUTF8: pointer.baseAddress!) == ":" {
                            strncpy(UnsafeMutablePointer(mutating: currentString), originalString, 19)
                            hasTimezone = true
                            hasMiliseconds = true
                        }
                    }
                    break
                default:
                    break
                }

                // Copy all the date excluding the timezone also set `hasTimezone` to YES.
                // Current date: 2014-01-01T00:00:00+00:00
                // Will become:  2014-01-01T00:00:00
                // Unit test B and C
                else if let string = String(validatingUTF8: &originalString[22]), originalLength == 25 && string == ":"{
                    strncpy(UnsafeMutablePointer(mutating: currentString), originalString, 19)
                    hasTimezone = true
                }

                // Copy all the date excluding the miliseconds and the Z.
                // Current date: 2014-03-30T09:13:00.000Z
                // Will become:  2014-03-30T09:13:00
                // Unit test G
                else if let string = String(validatingUTF8: &originalString[originalLength - 1]), originalLength == 24 && string == "Z" {
                    strncpy(UnsafeMutablePointer(mutating: currentString), originalString, 19)
                    hasMiliseconds = true
                }

                else if let string = String(validatingUTF8: &originalString[26]), originalLength == 29 && string == ":" {
                    strncpy(UnsafeMutablePointer(mutating: currentString), originalString, 19)
                    hasTimezone = true
                    hasMiliseconds = true
                }

                // Copy all the date excluding the microseconds and the timezone also set `hasTimezone` to YES.
                // Current date: 2015-08-23T09:29:30.007450+00:00
                // Will become:  2015-08-23T09:29:30
                // Unit test D
                else if let string = String(validatingUTF8: &originalString[29]), originalLength == 32 && string == ":" {
                    strncpy(UnsafeMutablePointer(mutating: currentString), originalString, 19)
                    hasTimezone = true
                    hasMicroseconds = true
                }

                // Copy all the date excluding the microseconds and the timezone.
                // Current date: 2015-09-10T13:47:21.116+0000
                // Will become:  2015-09-10T13:47:21
                // Unit test E
                else if let string = String(validatingUTF8: &originalString[23]), originalLength == 28 && string == "+" {
                    strncpy(UnsafeMutablePointer(mutating: currentString), originalString, 19)
                }

                // Copy all the date excluding the microseconds and the Z.
                // Current date: 2015-09-10T00:00:00.184968Z
                // Will become:  2015-09-10T00:00:00
                // Unit test F
                else if let milisecondDot = String(validatingUTF8: &originalString[19]), let timezoneIndicator = String(validatingUTF8: &originalString[originalLength - 1]), milisecondDot == "." && timezoneIndicator == "Z" {
                    strncpy(UnsafeMutablePointer(mutating: currentString), originalString, 19)
                }

                // Copy all the date excluding the miliseconds.
                // Current date: 2016-01-09T00:00:00.00
                // Will become:  2016-01-09T00:00:00
                // Unit test J
                else if let string = String(validatingUTF8: &originalString[19]), originalLength == 22 && string == "." {
                    strncpy(UnsafeMutablePointer(mutating: currentString), originalString, 19)
                    hasCentiseconds = true
                }

                // Poorly formatted timezone
                else {
                    strncpy(UnsafeMutablePointer(mutating: currentString), originalString, originalLength > 24 ? 24 : originalLength)
                }

                // Timezone
                let currentLength = Int(strlen(currentString))
                if hasTimezone {
                    // Add the first part of the removed timezone to the end of the string.
                    // Orignal date: 2015-06-23T14:40:08.000+02:00
                    // Current date: 2015-06-23T14:40:08
                    // Will become:  2015-06-23T14:40:08+02
                    strncpy(UnsafeMutablePointer(mutating: currentString) + currentLength, UnsafeMutablePointer(mutating: originalString) + originalLength - 6, 3)

                    // Add the second part of the removed timezone to the end of the string.
                    // Original date: 2015-06-23T14:40:08.000+02:00
                    // Current date:  2015-06-23T14:40:08+02
                    // Will become:   2015-06-23T14:40:08+0200
                    strncpy(UnsafeMutablePointer(mutating: currentString) + currentLength + 3, UnsafeMutablePointer(mutating: originalString) + originalLength - 2, 2)
                } else {
                    // Add GMT timezone to the end of the string
                    // Current date: 2015-09-10T00:00:00
                    // Will become:  2015-09-10T00:00:00+0000
                    strncpy(UnsafeMutablePointer(mutating: currentString) + currentLength, "+0000", 5)
                }

                // Add null terminator
                //currentString[sizeof(currentString) - 1] = 0

                // Parse the formatted date using `strptime`.
                // %F: Equivalent to %Y-%m-%d, the ISO 8601 date format
                //  T: The date, time separator
                // %T: Equivalent to %H:%M:%S
                // %z: An RFC-822/ISO 8601 standard timezone specification
                var tmc: tm = tm(tm_sec: 0, tm_min: 0, tm_hour: 0, tm_mday: 0, tm_mon: 0, tm_year: 0, tm_wday: 0, tm_yday: 0, tm_isdst: 0, tm_gmtoff: 0, tm_zone: nil)
                var shouldExit = false
                if strptime(UnsafeMutablePointer(mutating: currentString), "%FT%T%z", &tmc) == nil {
                    shouldExit = true
                }
                if shouldExit {
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
            } else {
                return nil
            }
        }
    }
    
    public init(unixTimestampString: String) {
        self.init()
    }
    
    public init(unixTimestampNumber: NSNumber) {
        self.init()
    }
}

public extension String {
    public func dateType() -> DateType {
        return .iso8601
    }
}
