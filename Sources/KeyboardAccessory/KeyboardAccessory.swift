//
//  KeyboardAccessory.swift
//  KeyboardAccessory
//
//  Created by Xavier Normant on 31/10/24.
//

import SwiftUI

public extension View {
    func keyboardAccessory<Content: View, Background: View>(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder background: @escaping () -> Background = { Color.clear }
    ) -> some View {
        modifier(KeyboardAccessoryModifier(accessory: content, background: background))
    }
}

struct KeyboardAccessoryModifier<Accessory: View, Background: View>: ViewModifier {
    @ViewBuilder let accessory: Accessory
    @ViewBuilder let background: Background

    @State
    private var height: CGFloat?

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
//                .safeAreaPadding(.bottom, self.height)
//                .ignoresSafeArea(.all, edges: .bottom)

            UIBottomBar.ViewRepresentable {
                self.accessory
            } background: {
                self.background.readSize { self.height = $0.height }
            }
        }
    }
}
