//
//  CitySearchAppUITests.swift
//  CitySearchAppUITests
//
//  Created by Oscar Cabanillas on 11/01/2026.
//

import XCTest

final class CitySearchAppUITests: XCTestCase {
    
    @MainActor
    func testDynamicSearchUpdatesList() throws {
        //Given
        let app = XCUIApplication()
        app.launchArguments.append("--use-mock")
        app.launch()
        
        //When
        let searchField = app.searchFields["Search for a city"]
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText("A")
        
        //Then
        sleep(1)
        
        let alabamaCell = app.cells.containing(.staticText, identifier: "cityListView.cell_4829764").firstMatch.exists
        let albuquerqueCell = app.cells.containing(.staticText, identifier: "cityListView.cell_5454711").firstMatch.exists
        let anaheimCell = app.cells.containing(.staticText, identifier: "cityListView.cell_5323810").firstMatch.exists
        let arizonaCell = app.cells.containing(.staticText, identifier: "cityListView.cell_5551752").firstMatch.exists
        let sydneyCell = app.cells.containing(.staticText, identifier: "cityListView.cell_2147714").firstMatch.exists
        
        XCTAssertTrue(alabamaCell)
        XCTAssertTrue(albuquerqueCell)
        XCTAssertTrue(anaheimCell)
        XCTAssertTrue(arizonaCell)
        
        XCTAssertFalse(sydneyCell)
    }
    
}
