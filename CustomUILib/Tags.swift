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
    
    public init(items: [T], content: @escaping (T) -> Content) {
        self._items = .constant(items)
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

@available(iOS 16.0, *)
public struct TagView2<Content: View>: View {
    let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        MyLayout {
            content()
        }
    }
    
    struct MyLayout: Layout {
        struct MyCache {
            struct Row {
                struct Item {
                    var frame: CGRect
                }
                var items: [Item]
            }
            var rows: [Row]
        }
        
        typealias Cache = MyCache
        
        func makeCache(subviews: Subviews) -> Cache {
            return .init(rows: [])
        }
        
        func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
            let superWidth = proposal.width ?? 100
            var currentWidth: CGFloat = 0
            var currentHeight: CGFloat = 0
            
            cache.rows = [.init(items: [])]
            
            for subv in subviews {
                let thisSize = subv.sizeThatFits(proposal)
                
                if thisSize.width + currentWidth <= superWidth {
                    let fr = CGRect(origin: .init(x: currentWidth, y: currentHeight), size: thisSize)
                    if let last = cache.rows.indices.last {
                        cache.rows[last].items.append(.init(frame: fr))
                    }
                    currentWidth += thisSize.width
                } else {
                    currentHeight += thisSize.height
                    let fr = CGRect(origin: .init(x: 0, y: currentHeight), size: thisSize)
                    cache.rows.append(.init(items: [.init(frame: fr)]))
                    currentWidth = thisSize.width
                }
            }
            
            let maxItem = cache.rows.map { r in
                return r.items
            }.flatMap { r in
                return r
            }.max { i1, i2 in
                return i1.frame.maxY < i2.frame.maxY
            }
            return .init(width: superWidth, height: maxItem?.frame.maxY ?? 0)
        }
        
        func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
            let allItems = cache.rows.map { r in
                return r.items
            }.flatMap { r in
                return r
            }
            
            let point = bounds.origin
            
            for (itm, i) in zip(allItems, subviews) {
                let p = CGPoint(x: itm.frame.origin.x + point.x, y: itm.frame.origin.y + point.y)
                i.place(at: p, anchor: .topLeading, proposal: proposal)
            }
        }
    }
}
