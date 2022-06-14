//
//  TestLoading.swift
//  SwiftUI_Customs
//
//  Created by zjj on 2022/6/13.
//

import SwiftUI

struct TestLoading: View {
    
    @State var loading = false
    
    var body: some View {
        Button("show loading") {
            loading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                loading = false
            }
        }
        .loading(isLoading: $loading, text: "Hello Loading")
    }
}

struct TestLoading_Previews: PreviewProvider {
    static var previews: some View {
        TestLoading()
    }
}
