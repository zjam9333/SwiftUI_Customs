//
//  Showing.swift
//  CustomUILib
//
//  Created by zjj on 2022/6/13.
//

import SwiftUI

struct PopOverModifier<PopContent: View>: ViewModifier {
    @Binding var popping: Bool
    let content: () -> PopContent
    
    @State private var backgroundOpacity: Double = 0
    @State private var contentOffset: CGFloat = 0
    @State private var contentOpacity: CGFloat = 0
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if popping {
                showingBody()
            }
        }
    }
    
    @ViewBuilder private func showingBody() -> some View {
        let dragGesture = DragGesture(minimumDistance: 1)
            .onChanged { ges in
                withAnimation {
                    if ges.translation.height > 0 {
                        // 阻力
                        contentOffset = ges.translation.height / 4
                    } else {
                        contentOffset = ges.translation.height / 2
                    }
                }
            }
            .onEnded { ges in
                let delta = ges.predictedEndTranslation.height - ges.translation.height
                if delta > 30 {
                    // 下拉收起
                    withAnimation(.easeInOut(duration: 0.25)) {
                        onHide()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        popping = false
                    }
                } else {
                    withAnimation {
                        contentOffset = 0
                    }
                }
            }
        
        GeometryReader { geo in
            VStack {
                Spacer()
                let bg = RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(colorScheme == .light ? .white : .black)
                    .frame(width: geo.size.width)
                    .padding(.bottom, contentOffset - 20 - geo.safeAreaInsets.bottom)
                
                // 主体内容
                self.content()
                    .background(bg)
                    .opacity(contentOpacity)
                    .offset(x: 0, y: contentOffset)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background((colorScheme == .light ? Color.black.opacity(backgroundOpacity) : Color.gray.opacity(backgroundOpacity)).edgesIgnoringSafeArea(.all))
            .contentShape(Rectangle())
            .onAppear {
                onHide()
                withAnimation(.easeInOut(duration: 0.25)) {
                    onShow()
                }
            }
            .gesture(dragGesture)
        }
    }
    
    private func onShow() {
        backgroundOpacity = 0.5
        contentOffset = 0
        contentOpacity = 1
    }
    
    private func onHide() {
        backgroundOpacity = 0
        contentOffset = 400
        contentOpacity = 0
    }
}
