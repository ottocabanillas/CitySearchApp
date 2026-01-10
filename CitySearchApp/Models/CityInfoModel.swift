//
//  CityInfoModel.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 09/01/2026.
//

import Foundation

struct CityInfoModel: Codable {
    //MARK: - Properties
    let query: Query
    
    //MARK: - Structs
    struct Query: Codable {
        let pages: [String: Page]
    }

    struct Page: Codable {
        let extract: String
    }
}
