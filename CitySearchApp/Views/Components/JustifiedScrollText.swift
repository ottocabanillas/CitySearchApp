//
//  JustifiedScrollText.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 09/01/2026.
//

import SwiftUI

struct JustifiedScrollText: UIViewRepresentable {
    let text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.textAlignment = .justified
        textView.isScrollEnabled = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = text
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 10
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}
