//
//  TestTagView.swift
//  SwiftUI_Customs
//
//  Created by zjj on 2022/10/11.
//

import SwiftUI
import CustomUILib

fileprivate struct IDModel<T>: Identifiable {
    let id = UUID()
    let obj: T
}

extension IDModel: Equatable where T: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension IDModel: Hashable where T: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(obj)
    }
}

struct TestTagView: View {
    
    let days: [String] = {
        var r = "L"
        var arr: [String] = []
        for i in 0..<20 {
            r += "."
            arr.append(r)
        }
        return arr
    }()
    
    @State fileprivate var selectedItems: Set<IDModel<String>> = []
    @State fileprivate var items: [IDModel<String>] = [
        .init(obj: "VeryVeryLongLongLongLongLongObject+OIJDSOFIJSDOFI"),
        .init(obj: "L0")
    ]
    
    var body: some View {
        //        ZStack(alignment: .topTrailing) {
        ScrollView {
            Button("add") {
                if let ranIndex = items.indices.randomElement() {
                    withAnimation {
                        items.insert(.init(obj: days.randomElement()!), at: ranIndex)
                    }
                }
            }
            
            if #available(iOS 16.0, *) {
                TagView2 {
                    ForEach(items) { s in
                        someBody(s: s)
                    }
                }
                .padding(5)
                .border(.blue)
            } else {
                TagView(items: items) { s in
                    someBody(s: s)
                }
                .padding(5)
                .border(.orange)
            }
        }
        .padding(.leading, 50)
    }
    
    private func someBody(s: IDModel<String>) -> some View {
        Text(s.obj)
            .lineLimit(1)
            .padding(5)
            .font(.body)
            .foregroundColor(Color.black)
            .border(selectedItems.contains(s) ? .blue : .yellow)
            .padding(5)
            .onTapGesture {
                withAnimation {
                    if selectedItems.contains(s) {
                        selectedItems.remove(s)
                    } else {
                        selectedItems.insert(s)
                    }
                }
            }
    }
}

struct TestTagView_Previews: PreviewProvider {
    static var previews: some View {
        TestTagView()
    }
}
