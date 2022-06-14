//
//  Loading.swift
//  CustomUILib
//
//  Created by zjj on 2022/6/13.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    @Binding var isLoading: Bool
    var text: String
    var textColor: Color = .white
    var font: Font = .body
    var backgroundColor: Color = .black.opacity(0.7)
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                VStack {
                    ActivityIndicatorView(style: .large, color: .white)
                    Text(text)
                        .font(font)
                        .foregroundColor(textColor)
                }
                .padding(10)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                .contentShape(Rectangle())
            }
        }
    }
}

struct ActivityIndicatorView: UIViewRepresentable {

    let isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    let color: UIColor?
    
    init(isAnimating: Bool = true, style: UIActivityIndicatorView.Style = .medium, color: UIColor? = nil) {
        self.isAnimating = isAnimating
        self.style = style
        self.color = color
    }

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
        let ac = UIActivityIndicatorView(style: style)
        if let color = color {
            ac.color = color
        }
        return ac
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
