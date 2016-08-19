@import Foundation;

static NSString * const HYPPropertyMapperDateNoTimestampFormat = @"YYYY-MM-DD";
static NSString * const HYPPropertyMapperTimestamp = @"T00:00:00+00:00";

typedef NS_ENUM(NSInteger, DateType) {
    ISO8601,
    UnixTimestamp
};

@interface NSDate (Parser)

+ (NSDate *)dateFromDateString:(NSString *)dateString;

// needs unit tests
+ (NSDate *)dateFromUnixTimestampString:(NSString *)unixTimestamp;

/*
 unixTimestamp shouldn't be more than NSIntegerMax (2,147,483,647)
 */
+ (NSDate *)dateFromUnixTimestampNumber:(NSNumber *)unixTimestamp;

// needs unit tests
+ (NSDate *)dateFromISO8601String:(NSString *)iso8601;

@end

@interface NSString (Parser)

- (DateType)dateType;

@end
