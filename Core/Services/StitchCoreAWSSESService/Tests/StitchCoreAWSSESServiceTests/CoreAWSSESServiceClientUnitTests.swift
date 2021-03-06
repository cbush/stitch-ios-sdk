import XCTest
import MongoSwift
import StitchCoreSDK
import StitchCoreSDKMocks
@testable import StitchCoreAWSSESService

final class CoreAWSSESServiceClientUnitTests: XCTestCase {
    func testSendEmail() throws {
        let service = MockCoreStitchServiceClient()
        let client = CoreAWSSESServiceClient(withService: service)

        let toEmail = "eliot@10gen.com"
        let from = "dwight@10gen.com"
        let subject = "Hello"
        let body = "again friend"

        let expectedMessageID = "yourMessageID"

        service.callFunctionWithDecodingMock.doReturn(
            result: AWSSESSendResult.init(messageID: expectedMessageID),
            forArg1: .any,
            forArg2: .any,
            forArg3: .any
        )

        let result = try client.sendEmail(toAddress: toEmail, fromAddress: from, subject: subject, body: body)

        XCTAssertEqual(expectedMessageID, result.messageID)

        let (funcNameArg, funcArgsArg, _) = service.callFunctionWithDecodingMock.capturedInvocations.last!

        XCTAssertEqual("send", funcNameArg)
        XCTAssertEqual(1, funcArgsArg.count)

        let expectedArgs: Document = [
            "toAddress": toEmail,
            "fromAddress": from,
            "subject": subject,
            "body": body
        ]

        XCTAssertEqual(expectedArgs, funcArgsArg[0] as? Document)

        // should pass along errors
        service.callFunctionWithDecodingMock.doThrow(
            error: StitchError.serviceError(withMessage: "", withServiceErrorCode: .unknown),
            forArg1: .any,
            forArg2: .any,
            forArg3: .any
        )

        do {
            _ = try client.sendEmail(toAddress: toEmail, fromAddress: from, subject: subject, body: body)
            XCTFail("function did not fail where expected")
        } catch {
            // do nothing
        }
    }
}
