//
//  RoundSlider.swift
//  SLPaymentDemo
//
//  Created by zjj on 2022/6/2.
//

import SwiftUI

public struct RoundSlider: View {
    
    public init(value: Binding<CGFloat>, in range: ClosedRange<CGFloat>) {
        self._value = value
        self.range = range
    }
    
    @Binding private var value: CGFloat
    private let range: ClosedRange<CGFloat>
    @State private var cachedTranslation: CGFloat = 0
    
    public var body: some View {
        GeometryReader { geo in
            let drag = DragGesture().onChanged { ges in
                if abs(cachedTranslation - ges.translation.width) < 1 {
                    // 防止无限递归。。
                    return
                }
                cachedTranslation = ges.translation.width
                if geo.size.width > 0 {
                    var testValue = range.lowerBound + (ges.location.x / geo.size.width) * (range.upperBound - range.lowerBound)
                    
                    if testValue < range.lowerBound {
                        testValue = range.lowerBound
                    } else if testValue > range.upperBound {
                        testValue = range.upperBound
                    }
                    if range.contains(testValue) {
                        value = testValue
                    }
                }
            }
            
            HStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(.accentColor)
                    .frame(width: range.isEmpty ? 0 : geo.size.width * (value - range.lowerBound) / (range.upperBound - range.lowerBound), height: geo.size.height)
                Rectangle()
                    .foregroundColor(.init(white: 0.9))
            }
            .clipShape(RoundedRectangle(cornerRadius: min(geo.size.width, geo.size.height) * 0.3, style: .continuous))
            .gesture(drag)
        }
    }
}
