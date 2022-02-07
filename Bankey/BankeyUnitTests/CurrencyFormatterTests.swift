//
//  CurrencyFormatterTests.swift
//  BankeyUnitTests
//
//  Created by Tinku István on 2022. 02. 08..
//

import Foundation
import XCTest

@testable import Bankey

class Test: XCTestCase {
    var formatter : CurrencyFormatter!
    
    override func setUp() {
        super.setUp()
        formatter = CurrencyFormatter()
    }
    
    func testBreakDollarsIntoCents() throws {
        let result = formatter.breakIntoDollarsAndCents(932143.45)
        XCTAssertEqual(result.0, "932,143")
        XCTAssertEqual(result.1, "45")
    }
    
    func testDollarsFormatted() throws {
        let result = formatter.dollarsFormatted(932143.45)
        XCTAssertEqual(result, "$932,143.45")
    }
    
    func testZeroDollarsFormatted() throws {
        let result = formatter.dollarsFormatted(0.00)
        XCTAssertEqual(result, "$0.00")
    }
}
