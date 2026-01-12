//
//  OrientationObserverTests.swift
//  CitySearchAppTests
//
//  Created by Oscar Cabanillas on 12/01/2026.
//

import XCTest
@testable import CitySearchApp

final class OrientationObserverTests: XCTestCase {
    // MARK: - Properties
    var sut: OrientationObserver!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        sut = OrientationObserver()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    // MARK: - Tests
    func testIsPortraitLogic() {
        //Given
        //When
        //Then
        XCTAssertTrue(sut.isPortrait(for: .portrait))
        XCTAssertTrue(sut.isPortrait(for: .unknown))
        XCTAssertTrue(sut.isPortrait(for: .faceUp))
        XCTAssertTrue(sut.isPortrait(for: .faceDown))
        XCTAssertFalse(sut.isPortrait(for: .landscapeLeft))
        XCTAssertFalse(sut.isPortrait(for: .landscapeRight))
        XCTAssertFalse(sut.isPortrait(for: .portraitUpsideDown))
        
    }
}
