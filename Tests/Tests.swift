import XCTest

class DateTests: XCTestCase {
    func testDateA() {
        let date = Date.dateWithDayString("2016-01-09")
        let resultDate = Date(dateString: "2016-01-09T00:00:00")
        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateB() {
        let date = Date.dateWithHourAndTimeZoneString("2014-03-30T09:13:00.000Z")
        let resultDate = Date(dateString: "2014-03-30T09:13:00Z")
        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateC() {
        let date = Date.dateWithDayString("2016-01-09")
        let resultDate = Date(dateString: "2016-01-09T00:00:00.00")
        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateD() {
        let date = Date.dateWithHourAndTimeZoneString("2015-06-23T19:04:19.911Z")
        let resultDate = Date(dateString: "2015-06-23T19:04:19.911Z")
        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateE() {
        let date = Date.dateWithDayString("2014-01-01")
        let resultDate = Date(dateString: "2014-01-01T00:00:00+00:00")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateF() {
        let date = Date.dateWithDayString("2014-01-02")
        let resultDate = Date(dateString: "2014-01-02")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateG() {
        let date = Date.dateWithDayString("2015-09-10")
        let resultDate = Date(dateString: "2015-09-10T00:00:00.000000Z")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }
    
    func testDateH() {
        let date = Date.dateWithDayString("2015-09-10")
        let resultDate = Date(dateString: "2015-09-10T00:00:00.000+0000")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateI() {
        let date = Date.dateWithHourAndTimeZoneString("2015-06-23T12:40:08.000")
        let resultDate = Date(dateString: "2015-06-23T14:40:08.000+02:00")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date.timeIntervalSince1970, resultDate!.timeIntervalSince1970)
    }

    func testDateJ() {
        let date = Date.dateWithDayString("2014-01-02")
        let resultDate = Date(dateString: "2014-01-02T00:00:00.000000+00:00")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    /*
    // No longer testable since now it will use fatalError instead of returning nil
    func testDateK() {
        let resultDate = Date(dateString: "2014-01-02T00:monsterofthelakeI'mhere00:00.007450+00:00")
        XCTAssertNil(resultDate)        
    }
    */

}

class TimestampDateTests: XCTestCase {
    func testTimestampA() {
        let date = Date.dateWithDayString("2015-09-10")
        let resultDate = Date(dateString: "1441843200")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testTimestampB() {
        let date = Date.dateWithDayString("2015-09-10")
        let resultDate = Date(dateString: "1441843200000000")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testTimestampC() {
        let date = Date.dateWithDayString("2015-09-10")
        let resultDate = Date(unixTimestampNumber: 1441843200)

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testTimestampD() {
        let date = Date.dateWithDayString("2015-09-10")
        let resultDate = Date(unixTimestampNumber: NSNumber(value: 1441843200000000.0))

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }
}

class OtherDateTests: XCTestCase {
    func testDateType() {
        let isoDateType = "2014-01-02T00:00:00.007450+00:00".dateType()
        XCTAssertEqual(isoDateType, DateType.iso8601)

        let timestampDateType = "1441843200000000".dateType()
        XCTAssertEqual(timestampDateType, DateType.unixTimestamp)
    }
}

extension Date {
    static func dateWithDayString(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "GMT")
        let date = formatter.date(from: dateString)!

        return date
    }

    static func dateWithHourAndTimeZoneString(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(identifier: "GMT")
        let date = formatter.date(from: dateString)!

        return date
    }

    func prettyPrint() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let string = formatter.string(from: self)
        print(string)
    }
}
