//
//  Page.swift
//  CustomUILib
//
//  Created by zjj on 2022/6/16.
//

import SwiftUI
import Combine

public struct PageControl: View {
    public init(currentPage: Int, pageCount: Int, tintColor: Color = .accentColor, normalColor: Color = .gray) {
        self.currentPage = currentPage
        self.pageCount = pageCount
        self.tintColor = tintColor
        self.normalColor = normalColor
    }
    
    let currentPage: Int
    let pageCount: Int
    let tintColor: Color
    let normalColor: Color
    
    public var body: some View {
        HStack(alignment: .center, spacing: 4) {
            ForEach(0..<pageCount, id: \.self) { index in
                Capsule(style: .circular)
                    .foregroundColor(index == currentPage ? tintColor : normalColor)
                    .frame(width: index == currentPage ? 8 : 4, height: 4)
            }
        }
        .animation(.default, value: currentPage)
    }
}

public struct PageView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    
    @Binding var currentPage: Int
    let datas: Data
    var pageContent: (Data.Element) -> Content
    
    public init(currentPage: Binding<Int> = .constant(0), datas: Data, @ViewBuilder page: @escaping (Data.Element) -> Content) {
        self._currentPage = currentPage
        self.datas = datas
        self.pageContent = page
    }
    
    @State private var contentOffset: CGSize = .zero
    
    @State private var lastCachedOffset: CGSize = .zero
    
    public var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let minOffset: CGFloat = 0
            let maxOffset: CGFloat = size.width * CGFloat(datas.count - 1)
            
            let drag = DragGesture(minimumDistance: 1)
                .onEnded { val in
                    withAnimation(.easeOut(duration: 0.2)) {
                        if size.width <= 0 {
                            return
                        }
                        if datas.isEmpty {
                            return
                        }
                        let range = 0...(datas.count - 1)
                        
                        // 处理左右两边、pageEnabled逻辑
                        let floatPage = contentOffset.width / size.width
                        var index = Int(floatPage + 0.5)
                        
                        // 惯性？
//                        let ra = abs(floatPage - .init(currentPage))
//                        if ra < 0.5 {
//                            let delta = val.predictedEndTranslation.width - val.translation.width
//                            var testIndex = index
//                            let minDelta: CGFloat = 30
//                            if delta > minDelta {
//                                testIndex = currentPage - 1
//                            } else if delta < -minDelta {
//                                testIndex = currentPage + 1
//                            }
//                            if range.contains(testIndex) {
//                                index = testIndex
//                            }
//                        }
                        
                        if index < range.lowerBound {
                            index = range.lowerBound
                        } else if index > range.upperBound {
                            index = range.upperBound
                        }
                        contentOffset.width = size.width * CGFloat(index)
                        lastCachedOffset = contentOffset
                    }
                }.onChanged { val in
                    // 简单处理滑动
                    let originalTranslation = val.translation.width
                    var testOffset = lastCachedOffset.width - originalTranslation
                    let boundRate: CGFloat = 0.3
                    var r: CGFloat = 0
                    if testOffset < minOffset {
                        r = testOffset - minOffset
                    } else if testOffset > maxOffset {
                        r = testOffset - maxOffset
                    }
                    testOffset += r * boundRate - r
                    contentOffset.width = testOffset
                }
            
            
            HStack(spacing: 0) {
                ForEach(datas, id: \.self) { i in
                    pageContent(i)
                        .frame(width: size.width, height: size.height)
                        .offset(x: -contentOffset.width)
                }
            }
            .onReceive(Just(contentOffset)) { rec in
                if size.width > 0 {
                    currentPage = Int(rec.width / size.width + 0.5)
                }
            }
            // 注意平时scrollView的contentOffset和这个offset是相反的
            .gesture(drag)
        }
        .clipped()
        .contentShape(Rectangle())
    }
}
