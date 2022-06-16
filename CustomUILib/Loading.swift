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
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                GeometryReader { g in
                    ZStack {
                        VStack {
                            LoadingView(leavesCount: 10)
                                .foregroundColor(colorScheme == .light ? .white : .black)
                            Text(text)
                                .font(.body)
                                .foregroundColor(colorScheme == .light ? .white : .black)
                        }
                        .padding(10)
                        .background(colorScheme == .light ? Color.black.opacity(0.7) : Color.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                    }
                    .frame(width: g.size.width, height: g.size.height)
                    .contentShape(Rectangle())
                    // 全屏遮挡
                }
            }
        }
    }
}

public struct LoadingView: View {
    
    public init(leavesCount: Int = 8) {
        totalCount = leavesCount
    }
    
    private let totalCount: Int
    @State private var indexShift: Int = 0
    private let time = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    public var body: some View {
        ZStack {
            ForEach(0..<totalCount, id: \.self) { a in
                let doubleIndex = Double(a)
                let doubleShiftIndex = Double((a + indexShift) % totalCount)
                Rectangle()
                    .cornerRadius(2)
                    .opacity(1 - (doubleShiftIndex) / Double(totalCount))
                    .frame(width: 4, height: 8)
                    .offset(y: -12)
                    .rotationEffect(.radians(-.pi * 2 / Double(totalCount) * doubleIndex))
                    .animation(.linear, value: indexShift)
            }.padding(16)
        }
        .onReceive(time) { out in
            var nex = indexShift + 1
            if nex >= totalCount {
                nex = 0
            }
            indexShift = nex
        }
    }
}
