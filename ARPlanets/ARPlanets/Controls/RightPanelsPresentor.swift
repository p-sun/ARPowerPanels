//
//  RightPanelsPresenter.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-24.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

private class Panel {
    /// A container for the viewToPresent
    let view = UIView()
    
    // The parent view presenting the panel
    let presentingView: UIView

    /// A priority determined by the user.
    /// When presenting a panel with a heigher height priority than the other panel, the height constraint is animated.
    /// Otherwise, don't animate the height.
    var heightPriority: Int!
    
    /// The left constraint on the view, so the panel can be animated.
    var leftConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    
    init(presentingView: UIView) {
        self.presentingView = presentingView
        setupContainer()
    }
    
    /// Constrain a view to the presentingView
    ///
    /// - Parameters:
    ///   - viewToPresent: A UIView with an optional height.
    ///   - width: The width of the panel.
    func constrainPanelToPresentor(viewToPresent: UIView, heightPriority: Int, width: CGFloat) {
        self.heightPriority = heightPriority
        
        // Constrain the height of all presented containers to be a square, with low priority
        // Want low priority because we want whatever height constraint or intrinsic size that a panel.view has to have higher priority
        heightConstraint = view.constrainHeight(width, relation: .equalOrGreater, priority: .defaultLow)
        
        view.constrainWidth(width)

        presentingView.addSubview(view)
        leftConstraint = view.constrainLeftToRight(of: presentingView)
        
        view.addSubview(viewToPresent)
        let insets = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        viewToPresent.constrainEdges(to: view, insets: insets)
    }
    
    private func setupContainer() {
        view.layer.cornerRadius = 20.0
        view.backgroundColor = UIColor.white.withAlphaComponent(1)
        view.clipsToBounds = true
        
        // Looks nice but is too slow
        // let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        // let blurEffectView = UIVisualEffectView(effect: blurEffect)
        // view.addSubview(blurEffectView)
        // blurEffectView.constrainEdges(to: view)
    }
}

class RightPanelsPresenter {
    
    private enum PresentationState {
        case isHidden, onTopPanel, onBottomPanel
    }
    
    private var topPanel: Panel?
    private var bottomPanel: Panel?

    // TODO on the ToolsMenu
    // If we have AR as main, can present the scene
    // If we have scene as main, can present the AR view
    
    /// If a panel is already presented, dismiss it.
    /// If there are two panels, replace the bottom panel.
    /// If we only have top, present the bottom.
    /// If we only have bottom, present the top.
    /// If we have none, present the top.
    func togglePanel(viewToPresent: UIView, heightPriority: Int, presentingView: UIView, width: CGFloat) {
        let state = presentationState(for: viewToPresent)
        
        switch state {
        case .isHidden:
            let panel = Panel(presentingView: presentingView)
            panel.constrainPanelToPresentor(viewToPresent: viewToPresent, heightPriority: heightPriority, width: width)
            
            if let _ = topPanel, let oldBottomPanel = bottomPanel {
                panel.view.constrainBottom(to: presentingView)
                self.bottomPanel = panel
                startAnimation(inPanel: panel, outPanel: oldBottomPanel, width: width)
                
            } else if topPanel == nil {
                panel.view.constrainTop(to: presentingView)
                topPanel = panel
                startAnimation(inPanel: panel, outPanel: nil, width: width)

            } else if bottomPanel == nil {
                panel.view.constrainBottom(to: presentingView)
                bottomPanel = panel
                startAnimation(inPanel: panel, outPanel: nil, width: width)
            }
            
        case .onTopPanel:
            let oldTopPanel = topPanel
            topPanel = nil
            startAnimation(inPanel: nil, outPanel: oldTopPanel, width: width)

        case .onBottomPanel:
            let oldBottomPanel = bottomPanel
            bottomPanel = nil
            startAnimation(inPanel: nil, outPanel: oldBottomPanel, width: width)
        }
    }
    
    private func presentationState(for targetView: UIView) -> PresentationState {
        if topPanel?.view.subviews.first == targetView {
            return .onTopPanel
        } else if bottomPanel?.view.subviews.first == targetView {
            return .onBottomPanel
        } else {
            return .isHidden
        }
    }
    
    private func startAnimation(inPanel: Panel?, outPanel: Panel?, width: CGFloat) {
        
        var middleConstraint: NSLayoutConstraint? = nil

        if let inPanel = inPanel, let topPanel = topPanel, let bottomPanel = bottomPanel {
                middleConstraint = topPanel.view.constrainBottomToTop(of: bottomPanel.view, offset: -20, isActive: false)
                let animateConstraints = shouldAnimateConstraints(inPanel: inPanel, topPanel: topPanel, bottomPanel: bottomPanel)
                if !animateConstraints {
                    middleConstraint?.isActive = true
                }
        }

        inPanel?.presentingView.layoutIfNeeded()

        UIView.animate(withDuration: 0.5, animations: {
            
            if let inPanel = inPanel { // weak self?
                let container = inPanel.view
                container.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                inPanel.leftConstraint?.constant = -container.bounds.width
                middleConstraint?.isActive = true
                inPanel.presentingView.layoutIfNeeded()
            }
            
            if let outPanel = outPanel {
                outPanel.view.backgroundColor = .clear
                outPanel.leftConstraint?.constant = 0
                outPanel.presentingView.layoutIfNeeded()
            }
            
        }, completion: { _ in
                outPanel?.view.removeFromSuperview()
        })
    }
    
    // If the target panel to animate in has heigher heighr priority than the other panel,
    // Animate the activation of the middle constraint to expand/shrunk the other panel.
    // Otherwise, activate the middle constraint before the animation, to expand/shrink the current panel before we slide it in.
    private func shouldAnimateConstraints(inPanel: Panel, topPanel: Panel, bottomPanel: Panel) -> Bool {
        if topPanel.view == inPanel.view {
            return topPanel.heightPriority > bottomPanel.heightPriority
        } else {
            return topPanel.heightPriority < bottomPanel.heightPriority
        }
    }
}
