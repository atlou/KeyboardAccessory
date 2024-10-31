//
//  UIBottomBar.Views.swift
//  BottomInputBarSwiftUI
//
//  Created by Cao, Jiannan on 1/10/24.
//

import UIKit

@MainActor
extension UIBottomBar {
    struct Views {
        let barView: UIView
        let backgroundView: UIView
        let floatingView: UIView
         
        @MainActor
        init(barView: UIView, backgroundView: UIView, superview: UIView) {
            barView.translatesAutoresizingMaskIntoConstraints = false
            self.barView = barView
            
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            self.backgroundView = backgroundView
            
            let floatingView = UIView()
            floatingView.translatesAutoresizingMaskIntoConstraints = false
            self.floatingView = floatingView
 
            superview.addSubview(floatingView)
            floatingView.addSubview(backgroundView)
            floatingView.addSubview(barView)
        }
    }
}
