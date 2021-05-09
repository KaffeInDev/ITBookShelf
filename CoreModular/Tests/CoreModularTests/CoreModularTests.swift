import XCTest
@testable import CoreModular

final class CoreModularTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CoreModular().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
