//
//  Modifier.swift
//  CustomUILib
//
//  Created by zjj on 2022/6/13.
//

import SwiftUI

extension View {
    public func toast(isPresenting: Binding<Bool>, text: String) -> some View {
        modifier(ToastModifier(isPresent: isPresenting, text: text))
    }
    
    public func loading(isLoading: Binding<Bool>, text: String) -> some View {
        modifier(LoadingModifier(isLoading: isLoading, text: text))
    }
    
    public func myShowing<ShowContent: View>(showing: Binding<Bool>, content: @escaping () -> ShowContent) -> some View {
        modifier(PopOverModifier(popping: showing, content: content))
    }
}
