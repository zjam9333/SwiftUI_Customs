//
//  SplitView.swift
//  Grids
//
//  Created by zjj on 2022/6/10.
//

import SwiftUI

public struct SplitView<T1: View, T2: View, T3: View>: View {
    public enum Axis {
        case horizontal
        case veritical
    }
    
    let axis: Axis
    
    let major: () -> T1
    let minor: () -> T2
    let dragLabel: () -> T3
    
    public init(axis: Axis = .veritical, @ViewBuilder major: @escaping () -> T1, @ViewBuilder minor: @escaping () -> T2, @ViewBuilder dragLabel: @escaping () -> T3) {
        self.axis = axis
        self.major = major
        self.minor = minor
        self.dragLabel = dragLabel
    }
    
    public init(axis: Axis = .veritical, @ViewBuilder major: @escaping () -> T1, @ViewBuilder minor: @escaping () -> T2) where T3 == EmptyView {
        self.axis = axis
        self.major = major
        self.minor = minor
        self.dragLabel = {
            return EmptyView()
        }
    }
    
    /// 0...1
    @State private var barOffset: CGSize = .init(width: 0.5, height: 0.5)
    @State private var lastCachedOffset: CGSize = .init(width: 0.5, height: 0.5)
    
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                let totalWidth = geo.size.width
                let totalHeight = geo.size.height
                
                if axis == .horizontal {
                    HStack(spacing: 0) {
                        major()
                            .frame(width: barOffset.width * totalWidth, height: totalHeight)
                        minor()
                            .frame(width: (1 - barOffset.width) * totalWidth, height: totalHeight)
                    }
                } else {
                    VStack(spacing: 0) {
                        major()
                            .frame(width: totalWidth, height: barOffset.height * totalHeight)
                        minor()
                            .frame(width: totalWidth, height: (1 - barOffset.height) * totalHeight)
                    }
                }
                
                let drag = DragGesture(minimumDistance: 0).onChanged { gesture in
                    guard geo.size.width > 0, geo.size.height > 0 else {
                        return
                    }
                    let tran = gesture.translation
                    var newWidth = lastCachedOffset.width + tran.width / totalWidth
                    var newHeight = lastCachedOffset.height + tran.height / totalHeight
                    if newWidth < 0.3 {
                        newWidth = 0.3
                    } else if newWidth > 0.7 {
                        newWidth = 0.7
                    }
                    if newHeight < 0.3 {
                        newHeight = 0.3
                    } else if newHeight > 0.7 {
                        newHeight = 0.7
                    }
                    barOffset = .init(width: newWidth, height: newHeight)
                }.onEnded { gesture in
                    lastCachedOffset = barOffset
                }
                
                let barWidth: CGFloat = 20
                if axis == .horizontal {
                    ZStack {
                        dragLabel()
                    }
                    .frame(width: barWidth, height: totalHeight)
                    .offset(.init(width: barOffset.width * totalWidth - barWidth / 2, height: 0))
                    .gesture(drag)
                } else {
                    ZStack {
                        dragLabel()
                    }
                    .frame(width: totalWidth, height: barWidth)
                    .offset(.init(width: 0, height: barOffset.height * totalHeight - barWidth / 2))
                    .gesture(drag)
                }
            }
        }
    }
}
