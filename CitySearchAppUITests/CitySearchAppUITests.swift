//
//  CitySearchAppUITests.swift
//  CitySearchAppUITests
//
//  Created by Oscar Cabanillas on 11/01/2026.
//

import XCTest

final class CitySearchAppUITests: XCTestCase {
    
    override func setUp() {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait
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
    
    func testaddFavoritesElement() throws {
        //Given
        let app = XCUIApplication()
        app.launchArguments.append("--use-mock")
        app.launch()
        
        //When
        app.buttons.matching(identifier: "cityListView.cell_5454711").element(boundBy: 1).tap()
        app/*@START_MENU_TOKEN@*/.switches["0"]/*[[".switches.switches[\"0\"]",".switches[\"0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        //Then
        sleep(1)
        
        let alabamaCell = app.cells.containing(.staticText, identifier: "cityListView.cell_4829764").firstMatch.exists
        let albuquerqueCell = app.cells.containing(.staticText, identifier: "cityListView.cell_5454711").firstMatch.exists
        let anaheimCell = app.cells.containing(.staticText, identifier: "cityListView.cell_5323810").firstMatch.exists
        let arizonaCell = app.cells.containing(.staticText, identifier: "cityListView.cell_5551752").firstMatch.exists
        let sydneyCell = app.cells.containing(.staticText, identifier: "cityListView.cell_2147714").firstMatch.exists
        
        XCTAssertTrue(alabamaCell)
        XCTAssertTrue(albuquerqueCell)
        XCTAssertTrue(sydneyCell)
        
        XCTAssertFalse(anaheimCell)
        XCTAssertFalse(arizonaCell)
    }
    
    func testNavigationToMapAndDetail() throws {
        //Given
        let app = XCUIApplication()
        app.launchArguments.append("--use-mock")
        app.launch()
        
        //When
        sleep(1)
        app.cells/*@START_MENU_TOKEN@*/.containing(.staticText, identifier: "cityListView.cell_4829764").firstMatch/*[[".element(boundBy: 0)",".containing(.button, identifier: \"cityListView.cell_4829764\").firstMatch",".containing(.staticText, identifier: \"cityListView.cell_4829764\").firstMatch"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        //Then
        XCTAssertTrue(app/*@START_MENU_TOKEN@*/.otherElements["Alabama"]/*[[".otherElements.otherElements[\"Alabama\"]",".otherElements[\"Alabama\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.exists)
        app/*@START_MENU_TOKEN@*/.buttons["BackButton"]/*[[".navigationBars",".buttons[\"Back\"]",".buttons[\"BackButton\"]",".buttons"],[[[-1,2],[-1,1],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app.buttons.matching(identifier: "cityListView.cell_4829764").element(boundBy: 0).tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Alabama, United States"]/*[[".otherElements.staticTexts[\"Alabama, United States\"]",".staticTexts",".staticTexts[\"Alabama, United States\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        XCTAssertTrue(app/*@START_MENU_TOKEN@*/.staticTexts["Alabama, United States"]/*[[".otherElements.staticTexts[\"Alabama, United States\"]",".staticTexts",".staticTexts[\"Alabama, United States\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.exists)
    }
    
    func testPortraitShowsSeparateScreens() throws {
        //Given
        let app = XCUIApplication()
        app.launchArguments.append("--use-mock")
        app.launch()

        //When
        sleep(1)
        
        //Then
        XCTAssertTrue(app.otherElements["PORTRAIT_VIEW"].exists)
        XCTAssertFalse(app.otherElements["LANDSCAPE_VIEW"].exists)
    }
    
    func testLandscapeShowsCombinedLayout() throws {
        //Given
        let app = XCUIApplication()
        app.launchArguments.append("--use-mock")
        app.launch()
        XCUIDevice.shared.orientation = .landscapeLeft
        //When
        sleep(2)
        
        //Then
        XCTAssertTrue(app.otherElements["LANDSCAPE_VIEW"].exists)
    }
}
