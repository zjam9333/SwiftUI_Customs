//
//  TestSizeView.swift
//  SwiftUI_Customs
//
//  Created by zjj on 2022/12/22.
//

import SwiftUI

struct TestSizeView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        let icon = Rectangle().background(.black).frame(width: 64, height: 64)
        let text = VStack {
            Text("Name: sadf")
            Text("Desc: flksafklfslkjfdl")
        }
        if horizontalSizeClass == .regular {
            HStack {
                icon
                text
            }
        } else {
            VStack {
                icon
                text
            }
        }
    }
}

struct TestSizeView_Previews: PreviewProvider {
    static var previews: some View {
        TestSizeView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("iPhone")
        
        TestSizeView()
            .previewDevice(PreviewDevice(rawValue: "iPad 6"))
            .previewDisplayName("iPad")
    }
}
