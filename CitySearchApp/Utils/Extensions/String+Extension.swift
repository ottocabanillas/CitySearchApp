//
//  String+Extension.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 09/01/2026.
//

import Foundation

extension String {
    func normalizedForSearch() -> String {
        self.folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
    }
}
