//
//  UIBottomBar.Constraints.swift
//  BottomInputBarSwiftUI
//
//  Created by Cao, Jiannan on 1/10/24.
//

import UIKit

protocol Constraints {
    associatedtype Source
    associatedtype Target
    init?(source: Source, target: Target?)
    func install()
    func uninstall()
    
    var constraints: [NSLayoutConstraint] { get }
}

extension Constraints {
    @MainActor
    func install() {
        NSLayoutConstraint.activate(constraints)
    }
    
    @MainActor
    func uninstall() {
        NSLayoutConstraint.deactivate(constraints)
    }
}

extension UIBottomBar {
    struct SuperViewConstraints : @preconcurrency Constraints {
        
        private let source: UIBottomBar.Views
        private let target: UIView
        let constraints: [NSLayoutConstraint]
        
        @MainActor
        init?(source: UIBottomBar.Views, target: UIView? = nil) {
            guard let target else { return nil }
            
            let barView = source.barView
            let backgroundView = source.backgroundView
            
            let constraints = [
                backgroundView.topAnchor.constraint(equalTo: target.topAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: target.bottomAnchor),
                backgroundView.leadingAnchor.constraint(equalTo: target.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo:target.trailingAnchor),
                
                barView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
                barView.bottomAnchor.constraint(lessThanOrEqualTo: backgroundView.bottomAnchor),
                barView.leadingAnchor.constraint(greaterThanOrEqualTo: backgroundView.leadingAnchor),
                barView.trailingAnchor.constraint(lessThanOrEqualTo: backgroundView.trailingAnchor)
            ]
            
            self.source = source
            self.target = target
            self.constraints = constraints
        }
    }
    
    @MainActor
    struct WindowConstraints : @preconcurrency Constraints {
        
        let source: UIBottomBar.Views
        let target: Target
        
        
        let constraints: [NSLayoutConstraint]
        
        
        init?(source: UIBottomBar.Views, target: Target?) {
            
            let barView = source.barView
            let backgroundView = source.backgroundView
            
            guard let target else { return nil }
            let window = target.window
            let keyboardLayoutGuide = target.keyboardLayoutGuide
            let safeAreaLayoutGuide = target.safeAreaLayoutGuide
            
            barView.setContentCompressionResistancePriority(.required, for: .horizontal)
            let constraints = [
                // backgroundView == window (without top)
                backgroundView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
                
                // hostingView | keyboard (V)
                barView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor),
                
                // hostingView == safeArea (H)
                barView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
                {
                    let constraint = barView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor)
                    constraint.priority = .defaultHigh - 1
                    return constraint
                }(),
                
                // hostingView <= safeArea
                barView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor),
                barView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor),
                barView.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor),
                barView.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor)
            ]
            
            self.source = source
            self.target = target
            self.constraints = constraints
        }
        
        func updateKeyboardDismissPadding() {
            target.keyboardLayoutGuide.keyboardDismissPadding = source.barView.intrinsicContentSize.height
        }
        
        struct Target {
            let window: UIWindow
            let keyboardLayoutGuide: UIKeyboardLayoutGuide
            let safeAreaLayoutGuide: UILayoutGuide
            
            @MainActor
            init?(window: UIWindow?) {
                guard let window, let rootView = window.rootViewController?.view else { return nil }
                self.window = window
                keyboardLayoutGuide = rootView.keyboardLayoutGuide
                safeAreaLayoutGuide = window.safeAreaLayoutGuide
            }
        }
    }
}


