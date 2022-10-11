//
//  Tags.swift
//  CustomUILib
//
//  Created by zjj on 2022/10/11.
//

import SwiftUI

public struct TagView<T: Identifiable, Content: View>: View {
    @Binding var items: [T]
    @ViewBuilder var content: (T) -> Content
    
    public init(items: Binding<[T]>, content: @escaping (T) -> Content) {
        self._items = items
        self.content = content
    }
    
    @State private var totalHeight = CGFloat.zero
    
    public var body: some View {
        if items.isEmpty {
            EmptyView()
        } else {
            GeometryReader { g in
                
                let gWidth: CGFloat = g.size.width
                var width = CGFloat.zero
                var height = CGFloat.zero
                
                ZStack(alignment: .topLeading) {
                    ForEach(items) { item in
                        content(item)
                            .alignmentGuide(.leading, computeValue: { d in
                                if (abs(width - d.width) > gWidth)
                                {
                                    width = 0
                                    height -= d.height
                                }
                                let result = width
                                if item.id == items.last?.id {
                                    width = 0 //last item
                                } else {
                                    width -= d.width
                                }
                                return result
                            })
                            .alignmentGuide(.top, computeValue: {d in
                                let result = height
                                if item.id == items.last?.id {
                                    height = 0 // last item
                                }
                                return result
                            })
                    }
                }
                .background(viewHeightReader($totalHeight))
            }
            .frame(height: totalHeight)
        }
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
