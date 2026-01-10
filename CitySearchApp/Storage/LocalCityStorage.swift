//
//  LocalCityStorage.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 08/01/2026.
//

import Foundation

protocol CityStorage {
    func load<T: Codable>(_ type: T.Type) throws -> T
    func save<T: Codable>(_ value: T) throws
}

//MARK: -
final class LocalCityStorage: CityStorage {
    //MARK: - Properties
    private let fileName = "fav_Cities_Ids.json"
    
    //MARK: - Methods
    func load<T>(_ type: T.Type) throws -> T where T : Decodable, T : Encodable {
        let url = try fileURL()
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw NSError(domain: "LocalStorage", code: 404, userInfo: [
                NSLocalizedDescriptionKey: "The file does not exist at \(url.path)"
            ])
            
        }
        
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func save<T>(_ value: T) throws where T : Decodable, T : Encodable {
        let data = try JSONEncoder().encode(value)
        try data.write(to: fileURL(), options: .atomic)
    }
}

//MARK: - Private Methods
extension LocalCityStorage {
    private func fileURL() throws -> URL {
        let folder = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        
        return folder.appendingPathComponent(fileName)
    }
}
