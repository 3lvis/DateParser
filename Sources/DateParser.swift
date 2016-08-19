import Foundation

struct DateParser {
    static var noTimestampFormat = "YYYY-MM-DD"
    static var timestamp = "T00:00:00+00:00"
}

public enum DateType {
    case iso8601, unixTimestamp
}

public extension NSDate {
    public convenience init?(dateString: String) {
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

    public convenience init?(iso8601String: String) {
        if iso8601String == NSNull() {
            return nil
        } else {
            var dateString = iso8601String
            if iso8601String.characters.count == DateParser.noTimestampFormat.characters.count {
                dateString.appendContentsOf(DateParser.timestamp)
            }

            if var originalString = dateString.cStringUsingEncoding(NSUTF8StringEncoding) {
                var originalLength = Int(strlen(originalString))
                if originalLength == 0 {
                    return nil
                }

                var currentString = ""
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

                // Copy all the date excluding the Z.
                // Current date: 2014-03-30T09:13:00Z
                // Will become:  2014-03-30T09:13:00
                // Unit test H
                if let string = String.fromCString(&originalString[originalLength - 1]) {
                    if originalLength == 20 && string == "Z" {
                        currentString.withCString { cstr in
                            strncpy(UnsafeMutablePointer(cstr), originalString, originalLength - 1);
                        }
                    }
                }

                // Copy all the date excluding the timezone also set `hasTimezone` to YES.
                // Current date: 2014-01-01T00:00:00+00:00
                // Will become:  2014-01-01T00:00:00
                // Unit test B and C
                else if let string = String.fromCString(&originalString[22]) {
                    if originalLength == 25 && string == ":" {
                        currentString.withCString { cstr in
                            strncpy(UnsafeMutablePointer(cstr), originalString, 19)
                            hasTimezone = true
                        }
                    }
                }

                // Copy all the date excluding the miliseconds and the Z.
                // Current date: 2014-03-30T09:13:00.000Z
                // Will become:  2014-03-30T09:13:00
                // Unit test G
                else if let string = String.fromCString(&originalString[originalLength - 1]) {
                    if originalLength == 24 && string == "Z" {
                        currentString.withCString { cstr in
                            strncpy(UnsafeMutablePointer(cstr), originalString, 19)
                            hasMiliseconds = true
                        }
                    }
                }

                // Copy all the date excluding the miliseconds and the timezone also set `hasTimezone` to YES.
                // Current date: 2015-06-23T12:40:08.000+02:00
                // Will become:  2015-06-23T12:40:08
                // Unit test A
                else if let string = String.fromCString(&originalString[26]) {
                    if originalLength == 29 && string == ":" {
                        currentString.withCString { cstr in
                            strncpy(UnsafeMutablePointer(cstr), originalString, 19)
                            hasTimezone = true
                            hasMiliseconds = true
                        }
                    }
                }

                // Copy all the date excluding the microseconds and the timezone also set `hasTimezone` to YES.
                // Current date: 2015-08-23T09:29:30.007450+00:00
                // Will become:  2015-08-23T09:29:30
                // Unit test D
                else if let string = String.fromCString(&originalString[29]) {
                    if originalLength == 32 && string == ":" {
                        currentString.withCString { cstr in
                            strncpy(UnsafeMutablePointer(cstr), originalString, 19)
                            hasTimezone = true
                            hasMicroseconds = true
                        }
                    }
                }

                    // Copy all the date excluding the microseconds and the timezone.
                    // Current date: 2015-09-10T13:47:21.116+0000
                    // Will become:  2015-09-10T13:47:21
                    // Unit test E
                else if let string = String.fromCString(&originalString[23]) {
                    if originalLength == 28 && string == "+" {
                        currentString.withCString { cstr in
                            strncpy(UnsafeMutablePointer(cstr), originalString, 19)
                        }
                    }
                }

                    // Copy all the date excluding the microseconds and the Z.
                    // Current date: 2015-09-10T00:00:00.184968Z
                    // Will become:  2015-09-10T00:00:00
                    // Unit test F
                else if originalString[19] == '.' && originalString[originalLength - 1] == 'Z' {
                    strncpy(currentString, originalString, 19);
                }

                    // Copy all the date excluding the miliseconds.
                    // Current date: 2016-01-09T00:00:00.00
                    // Will become:  2016-01-09T00:00:00
                    // Unit test J
                else if originalLength == 22 && originalString[19] == '.' {
                    strncpy(currentString, originalString, 19);
                    hasCentiseconds = YES;
                }

                    // Poorly formatted timezone
                else {
                    strncpy(currentString, originalString, originalLength > 24 ? 24 : originalLength);
                }

                // Timezone
                var currentLength = strlen(currentString)
                if hasTimezone {
                    // Add the first part of the removed timezone to the end of the string.
                    // Orignal date: 2015-06-23T14:40:08.000+02:00
                    // Current date: 2015-06-23T14:40:08
                    // Will become:  2015-06-23T14:40:08+02
                    strncpy(currentString + currentLength, originalString + originalLength - 6, 3);

                    // Add the second part of the removed timezone to the end of the string.
                    // Original date: 2015-06-23T14:40:08.000+02:00
                    // Current date:  2015-06-23T14:40:08+02
                    // Will become:   2015-06-23T14:40:08+0200
                    strncpy(currentString + currentLength + 3, originalString + originalLength - 2, 2);
                } else {
                    // Add GMT timezone to the end of the string
                    // Current date: 2015-09-10T00:00:00
                    // Will become:  2015-09-10T00:00:00+0000
                    strncpy(currentString + currentLength, "+0000", 5);
                }

                // Add null terminator
                currentString[sizeof(currentString) - 1] = 0;

                // Parse the formatted date using `strptime`.
                // %F: Equivalent to %Y-%m-%d, the ISO 8601 date format
                //  T: The date, time separator
                // %T: Equivalent to %H:%M:%S
                // %z: An RFC-822/ISO 8601 standard timezone specification
                struct tm tm;
                if (strptime(currentString, "%FT%T%z", &tm) == NULL) {
                    return nil;
                }

                time_t timeStruct = mktime(&tm);
                double time = (double)timeStruct;

                if hasCentiseconds || hasMiliseconds || hasMicroseconds {
                    NSString *trimmedDate = [dateString substringFromIndex:@"2015-09-10T00:00:00.".length];

                    if hasCentiseconds {
                        NSString *centisecondsString = [trimmedDate substringToIndex:@"00".length];
                        double centiseconds = centisecondsString.doubleValue / 100.0;
                        time += centiseconds;
                    }

                    if hasMiliseconds {
                        NSString *milisecondsString = [trimmedDate substringToIndex:@"000".length];
                        double miliseconds = milisecondsString.doubleValue / 1000.0;
                        time += miliseconds;
                    }

                    if hasMicroseconds {
                        NSString *microsecondsString = [trimmedDate substringToIndex:@"000000".length];
                        double microseconds = microsecondsString.doubleValue / 1000000.0;
                        time += microseconds;
                    }
                }

                return [NSDate dateWithTimeIntervalSince1970:time];
            } else {
                return nil
            }
        }
    }
    
    public convenience init(unixTimestampString: String) {
        self.init()
    }
    
    public convenience init(unixTimestampNumber: NSNumber) {
        self.init()
    }
}

public extension String {
    public func dateType() -> DateType {
        return .iso8601
    }
}