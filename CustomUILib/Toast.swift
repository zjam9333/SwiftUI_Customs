//
//  Toast.swift
//  Toast
//
//  Created by zjj on 2022/6/8.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isPresent: Bool
    var text: String
    
    var timeInternal: TimeInterval = 2
    var textColor: Color = .white
    var font: Font = .body
    var backgroundColor: Color = .black.opacity(0.5)
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresent {
                toastBody
            }
        }
    }
    
    @State private var bodyOpacity: CGFloat = 0
    var toastBody: some View {
        VStack {
            Spacer()
            Text(text)
                .font(font)
                .foregroundColor(textColor)
                .padding(4)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
        }
        .padding(.bottom, 100)
        .padding(.horizontal, 20)
        .opacity(bodyOpacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.1)) {
                bodyOpacity = 1
            }
            withAnimation(.easeInOut(duration: 0.1).delay(.init(timeInternal) - 0.1)) {
                bodyOpacity = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInternal) {
                isPresent = false
            }
        }
        .contentShape(Rectangle())
    }
}
