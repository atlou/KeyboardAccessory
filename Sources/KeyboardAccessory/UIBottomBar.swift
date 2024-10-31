//
//  UIButtonBar.swift
//  BottomInputBarSwiftUI
//
//  Created by Cao, Jiannan on 1/10/24.
//

import UIKit
import SwiftUI


class UIBottomBar : UIView {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var views: Views!
    
    init(barView: UIView, backgroundView: UIView, frame: CGRect = .zero) {
        super.init(frame: frame)
        self.views = Views(barView: barView, backgroundView: backgroundView, superview: self)
    }
    
    var keyboardConstraints: WindowConstraints? {
        didSet {
            oldValue?.uninstall()
            keyboardConstraints?.install()
        }
    }
    
    var superViewConstraints: SuperViewConstraints? {
        didSet {
            oldValue?.uninstall()
            superViewConstraints?.install()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        superViewConstraints = SuperViewConstraints(source: views,  target: views.floatingView)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        keyboardConstraints = WindowConstraints(source: views, target: WindowConstraints.Target(window: window))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        keyboardConstraints?.updateKeyboardDismissPadding()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        views.floatingView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
}

extension UIBottomBar {
    
    struct ViewRepresentable<BottomBar: View, Background: View> : UIViewRepresentable {
        @ViewBuilder
        let bottomBar: BottomBar
        
        @ViewBuilder
        let background :Background
        
        typealias UIViewType = UIBottomBar
        
        func makeUIView(context: Context) -> UIViewType {
            UIBottomBar(
                barView: _UIHostingView(rootView: bottomBar),
                backgroundView: _UIHostingView(rootView: background)
            )
        }
            
        func updateUIView(_ uiView: UIViewType, context: Context) {
            
        }
        
        func sizeThatFits(_ proposal: ProposedViewSize, uiView: Self.UIViewType, context: Self.Context) -> CGSize? {
            uiView.systemLayoutSizeFitting(
                {
                    var size = proposal.replacingUnspecifiedDimensions()
                    size.height = UIView.layoutFittingCompressedSize.height
                    return size
                }(),
                withHorizontalFittingPriority: .defaultHigh,
                verticalFittingPriority: .fittingSizeLevel
            )
        }
     }
}
