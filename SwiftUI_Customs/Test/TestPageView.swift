//
//  TestPageView.swift
//  SwiftUI_Customs
//
//  Created by zjj on 2022/6/16.
//

import SwiftUI

struct TestPageView: View {
    let colors: [Color] = [.red, .blue, .green, .yellow]
    @State var currentPage: Int = 3
    
    var body: some View {
        VStack {
            Text("System Page")
            TabView {
                ForEach(colors, id: \.self) { index in
                    ZStack {
                        Rectangle().foregroundColor(index)
                        .border(.brown, width: 2)
                        .padding(10)
    //                    Text("Text, \(index)")
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(width: 200, height: 100)
            .border(.green, width: 2)
            
            Spacer()
                .frame(height: 30)
            
            Text("My Page")
            PageView(currentPage: $currentPage, datas: colors) { index in
                ZStack {
                    Rectangle().foregroundColor(index)
                    .border(.brown, width: 2)
                    .padding(10)
//                    Text("Text, \(index)")
                }
            }
            .frame(width: 200, height: 100)
            .border(.green, width: 2)
            
            PageControl(currentPage: currentPage, pageCount: 4)
        }
        
    }
}

struct TestPageView_Previews: PreviewProvider {
    static var previews: some View {
        TestPageView()
    }
}
