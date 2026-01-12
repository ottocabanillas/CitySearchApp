//
//  OrientationObserver.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import Combine
import SwiftUI

final class OrientationObserver: ObservableObject {
    //MARK: - Published Properties
    @Published var isPortrait: Bool = true
    
    //MARK: - Private Properties
    private var cancellable: AnyCancellable?
    
    //MARK: - Initialization
    init() {
        updateOrientation()
        self.cancellable = NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .sink { [weak self] _ in
                self?.updateOrientation()
            }
    }
}

//MARK: - Private Methods
extension OrientationObserver {
    private func updateOrientation() {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .portrait,
             .unknown,
             .faceUp,
             .faceDown:
            isPortrait = true
        case .portraitUpsideDown,
             .landscapeLeft,
             .landscapeRight:
            isPortrait = false
        default:
            isPortrait = false
        }
    }
}
