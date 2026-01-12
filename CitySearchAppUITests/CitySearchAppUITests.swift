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
    
    func testFavoritesFilterFlow() throws {
        //Given
        let app = XCUIApplication()
        app.launchArguments.append("--use-mock")
        app.launch()
        
        //When
        app/*@START_MENU_TOKEN@*/.switches["0"]/*[[".switches.switches[\"0\"]",".switches[\"0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        //Then
        sleep(1)
        
        let alabamaCell = app.cells.containing(.staticText, identifier: "cityListView.cell_4829764").firstMatch.exists
        let albuquerqueCell = app.cells.containing(.staticText, identifier: "cityListView.cell_5454711").firstMatch.exists
        let anaheimCell = app.cells.containing(.staticText, identifier: "cityListView.cell_5323810").firstMatch.exists
        let arizonaCell = app.cells.containing(.staticText, identifier: "cityListView.cell_5551752").firstMatch.exists
        let sydneyCell = app.cells.containing(.staticText, identifier: "cityListView.cell_2147714").firstMatch.exists
        
        XCTAssertTrue(alabamaCell)
        XCTAssertTrue(sydneyCell)
        
        XCTAssertFalse(albuquerqueCell)
        XCTAssertFalse(anaheimCell)
        XCTAssertFalse(arizonaCell)
    }
    
    func testCityCellHasAllElements() throws {
        //Given
        let app = XCUIApplication()
        app.launchArguments.append("--use-mock")
        app.launch()

        
        //When
        let cell = app.cells.containing(.staticText, identifier: "cityListView.cell_4829764").firstMatch
        XCTAssertTrue(cell.exists)
        
        //Then
        let title = cell.staticTexts["Alabama, US"]
        XCTAssertTrue(title.exists)
        
        let subtitle = cell.staticTexts["Lat: 32.750408, Lon: -86.750259"]
        XCTAssertTrue(subtitle.exists)
        
        let infoButton = cell.buttons["Info"]
        XCTAssertTrue(infoButton.exists, "El botón de información debe estar presente en la celda")

        let favoriteButton = cell.buttons["Favorite"]
        XCTAssertTrue(favoriteButton.exists, "El botón de favorito debe estar presente en la celda")
    }
}
