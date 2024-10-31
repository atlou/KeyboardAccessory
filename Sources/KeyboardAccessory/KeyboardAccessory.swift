//
//  KeyboardAccessory.swift
//  KeyboardAccessory
//
//  Created by Xavier Normant on 31/10/24.
//

import SwiftUI

public extension View {
    func keyboardAccessory<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        modifier(KeyboardAccessoryModifier(accessory: content))
    }
}

struct KeyboardAccessoryModifier<Accessory: View>: ViewModifier {
    @ViewBuilder
    let accessory: Accessory

    @State
    private var height: CGFloat?

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
                .safeAreaPadding(.bottom, height)
                .ignoresSafeArea(.all, edges: .bottom)

            UIBottomBar.ViewRepresentable {
                accessory
            } background: {
                Color.clear.readSize { height = $0.height }
            }
        }
    }
}
