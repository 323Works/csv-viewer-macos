import XCTest
@testable import CSV_Viewer

final class CSVParserTests: XCTestCase {

    // MARK: - Parse Line Tests

    func testParseSimpleLine() {
        let line = "Name,Age,City"
        let result = CSVParser.parseLine(line)
        XCTAssertEqual(result, ["Name", "Age", "City"])
    }

    func testParseLineWithQuotedFields() {
        let line = "\"John Doe\",\"30\",\"New York\""
        let result = CSVParser.parseLine(line)
        XCTAssertEqual(result, ["John Doe", "30", "New York"])
    }

    func testParseLineWithCommasInQuotedFields() {
        let line = "\"Doe, John\",30,\"New York, NY\""
        let result = CSVParser.parseLine(line)
        XCTAssertEqual(result, ["Doe, John", "30", "New York, NY"])
    }

    func testParseLineWithEscapedQuotes() {
        let line = "\"He said \"\"Hello\"\"\",Test,Value"
        let result = CSVParser.parseLine(line)
        XCTAssertEqual(result, ["He said \"Hello\"", "Test", "Value"])
    }

    func testParseLineWithEmptyFields() {
        let line = "Name,,City"
        let result = CSVParser.parseLine(line)
        XCTAssertEqual(result, ["Name", "", "City"])
    }

    func testParseLineWithAllEmptyFields() {
        let line = ",,"
        let result = CSVParser.parseLine(line)
        XCTAssertEqual(result, ["", "", ""])
    }

    func testParseSingleField() {
        let line = "OnlyOneField"
        let result = CSVParser.parseLine(line)
        XCTAssertEqual(result, ["OnlyOneField"])
    }

    func testParseEmptyLine() {
        let line = ""
        let result = CSVParser.parseLine(line)
        XCTAssertEqual(result, [""])
    }

    func testParseLineWithNewlinesInQuotedFields() {
        let line = "\"First\nSecond\",Value,\"Third\nFourth\""
        let result = CSVParser.parseLine(line)
        XCTAssertEqual(result, ["First\nSecond", "Value", "Third\nFourth"])
    }

    // MARK: - Format Line Tests

    func testFormatSimpleLine() {
        let fields = ["Name", "Age", "City"]
        let result = CSVParser.formatLine(fields)
        XCTAssertEqual(result, "Name,Age,City")
    }

    func testFormatLineWithCommas() {
        let fields = ["Doe, John", "30", "New York, NY"]
        let result = CSVParser.formatLine(fields)
        XCTAssertEqual(result, "\"Doe, John\",30,\"New York, NY\"")
    }

    func testFormatLineWithQuotes() {
        let fields = ["He said \"Hello\"", "Test", "Value"]
        let result = CSVParser.formatLine(fields)
        XCTAssertEqual(result, "\"He said \"\"Hello\"\"\",Test,Value")
    }

    func testFormatLineWithNewlines() {
        let fields = ["First\nSecond", "Value", "Third"]
        let result = CSVParser.formatLine(fields)
        XCTAssertEqual(result, "\"First\nSecond\",Value,Third")
    }

    func testFormatEmptyFields() {
        let fields = ["Name", "", "City"]
        let result = CSVParser.formatLine(fields)
        XCTAssertEqual(result, "Name,,City")
    }

    func testFormatSingleField() {
        let fields = ["OnlyOne"]
        let result = CSVParser.formatLine(fields)
        XCTAssertEqual(result, "OnlyOne")
    }

    // MARK: - Round-trip Tests

    func testRoundTripSimpleData() {
        let original = ["Name", "Age", "City"]
        let formatted = CSVParser.formatLine(original)
        let parsed = CSVParser.parseLine(formatted)
        XCTAssertEqual(parsed, original)
    }

    func testRoundTripComplexData() {
        let original = ["Doe, John", "He said \"Hello\"", "New York, NY"]
        let formatted = CSVParser.formatLine(original)
        let parsed = CSVParser.parseLine(formatted)
        XCTAssertEqual(parsed, original)
    }

    func testRoundTripWithNewlines() {
        let original = ["First\nSecond", "Value", "Third\nFourth"]
        let formatted = CSVParser.formatLine(original)
        let parsed = CSVParser.parseLine(formatted)
        XCTAssertEqual(parsed, original)
    }

    func testRoundTripEmptyFields() {
        let original = ["", "Value", ""]
        let formatted = CSVParser.formatLine(original)
        let parsed = CSVParser.parseLine(formatted)
        XCTAssertEqual(parsed, original)
    }

    // MARK: - RFC 4180 Compliance Tests

    func testRFC4180Example1() {
        // Standard fields
        let line = "aaa,bbb,ccc"
        let result = CSVParser.parseLine(line)
        XCTAssertEqual(result, ["aaa", "bbb", "ccc"])
    }

    func testRFC4180Example2() {
        // Fields with embedded commas
        let line = "aaa,\"b,bb\",ccc"
        let result = CSVParser.parseLine(line)
        XCTAssertEqual(result, ["aaa", "b,bb", "ccc"])
    }

    func testRFC4180Example3() {
        // Fields with embedded double quotes
        let line = "aaa,\"b\"\"bb\",ccc"
        let result = CSVParser.parseLine(line)
        XCTAssertEqual(result, ["aaa", "b\"bb", "ccc"])
    }

    func testRFC4180Example4() {
        // Fields with embedded line breaks
        let line = "aaa,\"b\nbb\",ccc"
        let result = CSVParser.parseLine(line)
        XCTAssertEqual(result, ["aaa", "b\nbb", "ccc"])
    }
}
