//
//  FetchFailedView.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 09/01/2026.
//

import SwiftUI

struct FetchFailedView: View {
    let action: () async -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Oops! Something went wrong 😞")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Button {
                Task { await action() }
            } label: {
                Text("Try again")
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
