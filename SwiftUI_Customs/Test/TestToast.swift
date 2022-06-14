//
//  TestToast.swift
//  SwiftUI_Customs
//
//  Created by zjj on 2022/6/10.
//

import SwiftUI

struct TestToast: View {
    @State var presentingToast = false
    
    var body: some View {
        Button("show toast") {
            presentingToast = true
        }
        .toast(isPresenting: $presentingToast, text: "Hello Toast")
    }
}

struct TestToast_Previews: PreviewProvider {
    static var previews: some View {
        TestToast()
    }
}
