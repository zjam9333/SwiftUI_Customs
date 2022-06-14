//
//  TestSplitView.swift
//  SwiftUI_Customs
//
//  Created by zjj on 2022/6/10.
//

import SwiftUI

struct TestSplitView: View {
    var body: some View {
        let obj =
        SplitView(axis: .veritical) {
            ZStack {
                Rectangle()
                    .foregroundColor(.red)
                Text("1")
            }
        } minor: {
            SplitView(axis: .horizontal) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.blue)
                    Text("2")
                }
            } minor: {
                SplitView(axis: .veritical) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.green)
                        Text("3")
                    }
                } minor: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.cyan)
                        Text("4")
                    }
                } dragLabel: {
                    Image(systemName: "arrow.up.and.down.circle.fill")
                        .background(.yellow)
                }
            } dragLabel: {
                Image(systemName: "arrow.left.and.right.circle.fill")
                    .background(.yellow)
            }
        } dragLabel: {
            Image(systemName: "arrow.up.and.down.circle.fill")
                .background(.yellow)
        }
        return obj
    }
}

struct TestSplitView_Previews: PreviewProvider {
    static var previews: some View {
        TestSplitView()
    }
}
