//
//  FetchFailedView.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 09/01/2026.
//

import SwiftUI

struct FetchFailedView: View {
    //MARK: - Properties
    let action: () async -> Void
    
    //MARK: - Body
    var body: some View {
        VStack(spacing: 40) {
            Text("ERROR_MESSAGE")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Button {
                Task { await action() }
            } label: {
                Text("TRY_AGAIN_BUTTON")
                    .font(Font.title.bold())
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
    }
}

#Preview {
    FetchFailedView(action: {})
}
