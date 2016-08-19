import XCTest

class DateTests: XCTestCase {
    func testDateA() {
        let date = NSDate.dateWithHourAndTimeZoneString("2015-06-23T12:40:08.000")
        let resultDate = NSDate(fromDateString:"2015-06-23T14:40:08.000+02:00")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date.timeIntervalSince1970, resultDate.timeIntervalSince1970)
    }

    func testDateB() {
        let date = NSDate.dateWithDayString("2014-01-01")
        let resultDate = NSDate(fromDateString:"2014-01-01T00:00:00+00:00")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateC() {
        let date = NSDate.dateWithDayString("2014-01-02")
        let resultDate = NSDate(fromDateString:"2014-01-02")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateD() {
        let date = NSDate.dateWithDayString("2014-01-02")
        let resultDate = NSDate(fromDateString:"2014-01-02T00:00:00.000000+00:00")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateE() {
        let date = NSDate.dateWithDayString("2015-09-10")
        let resultDate = NSDate(fromDateString:"2015-09-10T00:00:00.116+0000")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateF() {
        let date = NSDate.dateWithDayString("2015-09-10")
        let resultDate = NSDate(fromDateString:"2015-09-10T00:00:00.184968Z")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateG() {
        let date = NSDate.dateWithHourAndTimeZoneString("2015-06-23T19:04:19.911Z")
        let resultDate = NSDate(fromDateString:"2015-06-23T19:04:19.911Z")
        print(date.timeIntervalSince1970)
        print(resultDate.timeIntervalSince1970)
        date.prettyPrint()

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateH() {
        let date = NSDate.dateWithHourAndTimeZoneString("2014-03-30T09:13:00.000Z")
        let resultDate = NSDate(fromDateString:"2014-03-30T09:13:00Z")
        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateI() {
        let resultDate = NSDate(fromDateString:"2014-01-02T00:monsterofthelakeI'mhere00:00.007450+00:00")
        XCTAssertNil(resultDate)        
    }

    func testDateJ() {
        let date = NSDate.dateWithDayString("2016-01-09")
        let resultDate = NSDate(fromDateString:"2016-01-09T00:00:00.00")
        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateK() {
        let date = NSDate.dateWithDayString("2016-01-09")
        let resultDate = NSDate(fromDateString:"2016-01-09T00:00:00")
        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }
}

class TimestampDateTests: XCTestCase {
    func testTimestampA() {
        let date = NSDate.dateWithDayString("2015-09-10")
        let resultDate = NSDate(fromDateString:"1441843200")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testTimestampB() {
        let date = NSDate.dateWithDayString("2015-09-10")
        let resultDate = NSDate(fromDateString:"1441843200000000")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testTimestampC() {
        let date = NSDate.dateWithDayString("2015-09-10")
        let resultDate = NSDate(fromUnixTimestampNumber: 1441843200)

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testTimestampD() {
        let date = NSDate.dateWithDayString("2015-09-10")
        let resultDate = NSDate(fromUnixTimestampNumber: NSNumber(double: 1441843200000000.0))

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }
}

class OtherDateTests: XCTestCase {
    func testDateType() {
        let isoDateType = "2014-01-02T00:00:00.007450+00:00".dateType()
        XCTAssertEqual(isoDateType, DateType.ISO8601)

        let timestampDateType = "1441843200000000".dateType()
        XCTAssertEqual(timestampDateType, DateType.UnixTimestamp)
    }
}

extension NSDate {
    static func dateWithDayString(dateString: String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone(name: "GMT")
        let date = formatter.dateFromString(dateString)!

        return date
    }

    static func dateWithHourAndTimeZoneString(dateString: String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(name: "GMT")
        let date = formatter.dateFromString(dateString)!

        return date
    }

    func prettyPrint() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let string = formatter.stringFromDate(self)
        print(string)
    }
}
