//
//  OrientationObserver.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import Combine
import SwiftUI

final class OrientationObserver: ObservableObject {
    @Published var isPortrait: Bool = true
    
    private let screen: UIScreen?
    private var cancellable: AnyCancellable?
    
    init(screen: UIScreen? = nil) {
        if let screen = screen {
            self.screen = screen
        } else {
            self.screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen
        }
        updateOrientation()
        self.cancellable = NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .sink { [weak self] _ in
                self?.updateOrientation()
            }
    }
    
    private func updateOrientation() {
        let orientation = UIDevice.current.orientation
        if orientation.isValidInterfaceOrientation && !orientation.isFlat {
            self.isPortrait = orientation.isPortrait
        } else if let screen = self.screen {
            self.isPortrait = screen.bounds.height >= screen.bounds.width
        } else {
            self.isPortrait = true
        }
    }
}
