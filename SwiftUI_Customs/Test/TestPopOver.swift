//
//  TestPopOver.swift
//  SwiftUI_Customs
//
//  Created by zjj on 2022/6/13.
//

import SwiftUI

struct TestPopOver: View {
    
    @State var popping = false
    
    @State var fontSize: CGFloat = 24
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button("1. my pop over") {
                popping = true
            }
        }
        .myShowing(showing: $popping) {
            showingBody()
        }
    }
    
    @ViewBuilder func showingBody() -> some View {
        VStack(spacing: 20) {
            Text(String(format: "Hello, World! Use the truncationMode(_:) modifier to determine whether text in a long line is truncated at the beginning, middle, or end. font size %.1f", fontSize))
                .truncationMode(.middle)
                .font(.system(size: fontSize))
            
            HStack {
                Circle()
                    .frame(width: fontSize, height: fontSize)
                RoundSlider(value: $fontSize, in: 10...128)
                    .frame(height: 20)
            }
        }
        .padding()
    }
}

struct TestPopOver_Previews: PreviewProvider {
    static var previews: some View {
        TestPopOver()
    }
}
