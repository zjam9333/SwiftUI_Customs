//
//  TestRoundSlider.swift
//  SwiftUI_Customs
//
//  Created by zjj on 2022/6/10.
//

import SwiftUI
import CustomUILib

struct TestRoundSlider: View {
    @State var fontSize: CGFloat = 24
    @State var test: CGFloat = 24
    var body: some View {
            VStack(spacing: 20) {
                Text(String(format: "Hello, World! %.2f", fontSize))
                    .font(.system(size: fontSize))
                
                HStack {
                    Circle()
                        .frame(width: fontSize, height: fontSize)
                    RoundSlider(value: $fontSize, in: 10...64)
                        .frame(height: 20)
                }
            }
            .padding()
    }
}

struct TestRoundSlider_Previews: PreviewProvider {
    static var previews: some View {
        TestRoundSlider()
    }
}
