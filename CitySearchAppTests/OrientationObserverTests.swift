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
        XCTAssertTrue(sut.isPortrait(for: .portrait), "Debe ser true para .portrait")
        XCTAssertTrue(sut.isPortrait(for: .unknown), "Debe ser true para .unknown")
        XCTAssertTrue(sut.isPortrait(for: .faceUp), "Debe ser false para .faceUp")
        XCTAssertTrue(sut.isPortrait(for: .faceDown), "Debe ser false para .faceDown")
        XCTAssertFalse(sut.isPortrait(for: .landscapeLeft), "Debe ser false para .landscapeLeft")
        XCTAssertFalse(sut.isPortrait(for: .landscapeRight), "Debe ser false para .landscapeRight")
        XCTAssertFalse(sut.isPortrait(for: .portraitUpsideDown), "Debe ser false para .portraitUpsideDown")
    }
}
