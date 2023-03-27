//
//  Adapt.swift
//  CustomUILib
//
//  Created by zjj on 2022/12/22.
//

import SwiftUI

struct AdaptView<Content: View>: View {
    let threshold: CGFloat
    let content: () -> Content
    @State var testWidth: CGFloat = 0
    
    init(threshold: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.threshold = threshold
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    testWidth = size.width
                }
            
            if testWidth > threshold {
                VStack {
                    content()
                }
            } else {
                HStack {
                    content()
                }
            }
        }
    }
}

fileprivate struct TestAdapt: View {
    
    @State var currentWidth: CGFloat = 0
    @State var padding: CGFloat = 8
    @State var threshold: CGFloat = 100
    
    var body: some View {
        VStack {
            AdaptView(threshold: threshold) {
                RoundedRectangle(cornerRadius: 40.0, style: .continuous)
                    .fill(
                        Color.black
                    )
                RoundedRectangle(cornerRadius: 40.0, style: .continuous)
                    .fill(
                        Color.gray
                    )
            }
            .readSize { size in
                currentWidth = size.width
            }
            .overlay(
                Rectangle()
                    .stroke(lineWidth: 2)
                    .frame(width: threshold)
            )
            .padding(.horizontal, padding)
            
            Text("Current width: \(Int(currentWidth))")
            HStack {
                Text("Threshold: \(Int(threshold))")
                Slider(value: $threshold, in: 0...1500, step: 1) { Text("") }
            }
            HStack {
                Text("Padding:")
                Slider(value: $padding, in: 0...500, step: 1) { Text("") }
            }
        }
        .padding()
    }
}

struct Adapt_Previews: PreviewProvider {
    
    static var previews: some View {
        TestAdapt()
    }
}
