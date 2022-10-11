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
        return lhs.obj == rhs.obj
    }
}

extension IDModel: Hashable where T: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(obj)
    }
}

struct TestTagView: View {
    
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    @State fileprivate var selectedItems: Set<IDModel<String>> = []
    @State fileprivate var items: [IDModel<String>] = [.init(obj: "Monday")]
    
    var body: some View {
        //        ZStack(alignment: .topTrailing) {
        ScrollView {
            Button("add") {
                items.insert(.init(obj: days.randomElement()!), at: 0)
            }
            
            TagView(items: $items) { s in
                Text(s.obj)
                    .lineLimit(1)
                    .padding(5)
                    .font(.body)
                    .background(selectedItems.contains(s) ? Color.blue : Color.gray)
                    .foregroundColor(Color.white)
                    .cornerRadius(5)
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
            .padding(5)
            .border(.orange)
        }
    }
}

struct TestTagView_Previews: PreviewProvider {
    static var previews: some View {
        TestTagView()
    }
}
