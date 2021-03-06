import XCTest
import Foundation
@testable import StitchCoreRemoteMongoDBService

final class CoreRemoteMongoClientUnitTests: XCTestCase {
    func testGetDatabase() throws {
        let client = TestUtils.getClient()

        let db1 = client.db("dbName1")
        XCTAssertEqual("dbName1", db1.name)

        let db2 = client.db("dbName2")
        XCTAssertEqual("dbName2", db2.name)
    }
}
