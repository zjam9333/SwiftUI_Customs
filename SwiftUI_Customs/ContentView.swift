//
//  ContentView.swift
//  SwiftUI_Customs
//
//  Created by zjj on 2022/6/10.
//

import SwiftUI
@_exported import CustomUILib

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    testCell {
                        TestTagView()
                    }
                    testCell {
                        TestToast()
                    }
                    testCell {
                        TestSplitView()
                    }
                    testCell {
                        TestRoundSlider()
                    }
                    testCell {
                        TestLoading()
                    }
                    testCell {
                        TestPopOver()
                    }
                    testCell {
                        TestPageView()
                    }
                    testCell {
                        TestSizeView()
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Custom Views")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder func testCell<T: View>(destination: () -> T) -> some View {
        let title = String(describing: T.self)
        NavigationLink(title) {
            destination()
                .navigationTitle(title)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
