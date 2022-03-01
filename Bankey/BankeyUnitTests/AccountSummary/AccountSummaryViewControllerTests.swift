//
//  AccountSummaryViewControllerTests.swift
//  BankeyUnitTests
//
//  Created by Tinku István on 2022. 03. 01..
//

import Foundation
import XCTest

@testable import Bankey

class AccountSummaryViewControllerTests: XCTestCase {
    var vc: AccountSummaryViewController!
    var mockManager: MockProfileManager!
    
    class MockProfileManager: ProfileManageable {
        var profile: Profile?
        var error: NetworkError?
        
        func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void) {
            if error != nil {
                completion(.failure(error!))
                return
            }
            profile = Profile(id: "1", firstName: "FirstName", lastName: "LastName")
            completion(.success(profile!))
        }
    }
    
    override func setUp() {
        super.setUp()
        self.vc = AccountSummaryViewController()
        
        mockManager = MockProfileManager()
        vc.profileManager = mockManager
    }
    
    func testTitleAndMessageForServerError() throws {
        let titleAndMessage = vc.titleAndMessageForTesting(.serverError)
        XCTAssertEqual(titleAndMessage.0, "Server Error")
        XCTAssertEqual(titleAndMessage.1, "Ensure you are connected to the internet. Please try again.")
    }
    
    func testTitleAndMessageForDecodingError() throws {
        let titleAndMessage = vc.titleAndMessageForTesting(.decodingError)
        XCTAssertEqual(titleAndMessage.0, "Decoding Error")
        XCTAssertEqual(titleAndMessage.1, "We could not process your request. Please try again.")
    }
    
    func testAlertForServerError() throws {
        mockManager.error = NetworkError.serverError
        vc.fetchProfileForTesting()
        
        XCTAssertEqual(vc.errorAlert.title, "Server Error")
        XCTAssertEqual(vc.errorAlert.message, "Ensure you are connected to the internet. Please try again.")
    }
    
    func testAlertForDecodingError() throws {
        mockManager.error = NetworkError.decodingError
        vc.fetchProfileForTesting()
        
        XCTAssertEqual(vc.errorAlert.title, "Decoding Error")
        XCTAssertEqual(vc.errorAlert.message, "We could not process your request. Please try again.")
    }
}
