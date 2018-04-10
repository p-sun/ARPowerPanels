//
//  Panel.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-27.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

class Panel {
    /// A container for the viewToPresent
    let view = UIView()
    
    /// A priority determined by the user.
    /// When presenting a panel with a heigher height priority than the other panel, the height constraint is animated.
    /// Otherwise, don't animate the height.
    var heightPriority: UILayoutPriority!
    
    /// The left constraint on the view, so the panel can be animated.
    var leftConstraint: NSLayoutConstraint!    
    var heightConstraint: NSLayoutConstraint
    weak var middleConstraint: NSLayoutConstraint?
    
    init(width: CGFloat) {
        view.constrainWidth(width)
        
        // Constrain the height of all presented containers to be a square, with low priority
        // Low priority because we want it to be a square if a height cannot be calculated
        heightConstraint = view.constrainHeight(width, relation: .equalOrGreater, priority: .defaultLow)
        
        setupContainer()
    }
    
    /// Constrain a view to the presentingView
    ///
    /// - Parameters:
    ///   - viewToPresent: A UIView with an optional height constraint.
    ///   - heightPriority: Priority of the height constraint. If a
    ///   - presentingView: The view containing all the panels (i.e. a viewController.view
    func constrainToPresenter(viewToPresent: UIView, heightPriority: UILayoutPriority, presentingView: UIView) {
        self.heightPriority = heightPriority
        
        presentingView.addSubview(view)
        leftConstraint = view.constrainLeftToRight(of: presentingView)
        
        view.addSubview(viewToPresent)
//        viewToPresent.constrainEdgesHorizontally(to: view, leftInsets: 20, rightInsets: 20)
//        viewToPresent.constrainTop(to: view, offset: 10)
//        viewToPresent.constrainBottom(to: view, offset: -20, relation: .equalOrGreater, priority: .init(999))
        
        let insets = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        viewToPresent.constrainEdges(to: view, insets: insets)
    }
    
    private func setupContainer() {
        view.addCornerRadius()
        view.backgroundColor = UIColor.white // A flash of color when a new panel is presented
    }
}
