//
//  RightPanelsPresenter.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-24.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

// This could use some refactoring
private class Panel {
    /// A container for the viewToPresent
    let view = UIView()
    
    /// A priority determined by the user.
    /// When presenting a panel with a heigher height priority than the other panel, the height constraint is animated.
    /// Otherwise, don't animate the height.
    var heightPriority: Int!
    
    /// The left constraint on the view, so the panel can be animated.
    var leftConstraint: NSLayoutConstraint!
    
    var heightConstraint: NSLayoutConstraint
    
    var middleConstraint: NSLayoutConstraint? = nil
    
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
    func constrainToPresenter(viewToPresent: UIView, heightPriority: Int, presentingView: UIView) {
        self.heightPriority = heightPriority
        
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
    }
}

protocol RightPanelsPresenterDelegate: class {
    func rightPanelsPresenter(didPresent view: UIView)
    func rightPanelsPresenter(didDismiss view: UIView)
}

class RightPanelsPresenter {
    
    private enum PresentationState {
        case isHidden, onTopPanel, onBottomPanel
    }
    
    private var topPanel: Panel?
    private var bottomPanel: Panel?

    // The parent view presenting the panel
    weak var presentingView: UIView?
    
    weak var delegate: RightPanelsPresenterDelegate?
    
    init(presentingView: UIView) {
        self.presentingView = presentingView
    }
    
    // TODO on the ToolsMenu
    // If we have AR as main, can present the scene
    // If we have scene as main, can present the AR view
    
    func togglePanel(viewToPresent: UIView, heightPriority: Int, width: CGFloat) {
        guard let presentingView = presentingView else {
            fatalError("shouldn't happen")
        }
        
        let state = presentationState(for: viewToPresent)
        
        switch state {
        case .isHidden:
            let panel = Panel(width: width)
            panel.constrainToPresenter(viewToPresent: viewToPresent, heightPriority: heightPriority, presentingView: presentingView)
            
            // There are two panels, replace the bottom panel.
            if let topPanel = topPanel, let oldBottomPanel = bottomPanel {
                let shouldAnimateHeight = oldBottomPanel.heightPriority > topPanel.heightPriority
                
                panel.view.constrainBottom(to: presentingView)
                self.bottomPanel = panel
                startAnimation(inPanel: panel, outPanel: oldBottomPanel, oldBottomPanel: oldBottomPanel, shouldAnimateHeight: shouldAnimateHeight, width: width)
            
            // If we have none on top, present the top.
            // If we have nothing on top, something on the bottom, present the top
            } else if topPanel == nil {
                panel.view.constrainTop(to: presentingView)
                topPanel = panel
                startAnimation(inPanel: panel, outPanel: nil, width: width)

            // If we have nothing on bottom, something on the top, present the bottom
            } else {
                panel.view.constrainBottom(to: presentingView)
                bottomPanel = panel
                startAnimation(inPanel: panel, outPanel: nil, width: width)
            }
        
        // If a panel is already presented, dismiss it.
        case .onTopPanel:
            let oldTopPanel = topPanel!
            topPanel = nil
            let shouldAnimateHeight: Bool
            if let bottomPanel = bottomPanel {
                shouldAnimateHeight = oldTopPanel.heightPriority > bottomPanel.heightPriority
            } else {
                shouldAnimateHeight = false // middleConstraint doesn't exist when there there wasn't two panels
            }
            
            startAnimation(inPanel: nil, outPanel: oldTopPanel, oldBottomPanel: bottomPanel, shouldAnimateHeight: shouldAnimateHeight, width: width)

        // If a panel is already presented, dismiss it.
        case .onBottomPanel:
            let oldBottomPanel = bottomPanel!
            bottomPanel = nil
            
            let shouldAnimateHeight: Bool
            if let topPanel = topPanel {
               shouldAnimateHeight = oldBottomPanel.heightPriority > topPanel.heightPriority
            } else {
                shouldAnimateHeight = false // middleConstraint doesn't exist when there there wasn't two panels
            }
            
            startAnimation(inPanel: nil, outPanel: oldBottomPanel, oldBottomPanel: oldBottomPanel, shouldAnimateHeight: shouldAnimateHeight, width: width)
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
    
    private func informDelegates(inPanel: Panel?, outPanel: Panel?) {
        if let inPanel = inPanel, let subview = inPanel.view.subviews.first {
            delegate?.rightPanelsPresenter(didPresent: subview)
        }
        if let outPanel = outPanel, let subview = outPanel.view.subviews.first {
            delegate?.rightPanelsPresenter(didDismiss: subview)
        }
    }
    
    private func startAnimation(inPanel: Panel?, outPanel: Panel?, oldBottomPanel: Panel? = nil, shouldAnimateHeight: Bool = false, width: CGFloat) {

        informDelegates(inPanel: inPanel, outPanel: outPanel)
        
        var middleConstraint: NSLayoutConstraint? = nil
        
        if let inPanel = inPanel, let topPanel = topPanel, let bottomPanel = bottomPanel {
                middleConstraint = topPanel.view.constrainBottomToTop(of: bottomPanel.view, offset: -20, isActive: false)
                bottomPanel.middleConstraint = middleConstraint // Store the middleConstraint in the bottomPanel
            
                let animateConstraints = shouldAnimateConstraints(inPanel: inPanel, topPanel: topPanel, bottomPanel: bottomPanel)
                if !animateConstraints {
                    middleConstraint?.isActive = true
                }
        }

        presentingView?.layoutIfNeeded()

        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            
            if let inPanel = inPanel {
                let container = inPanel.view
                container.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                inPanel.leftConstraint?.constant = -container.bounds.width
                middleConstraint?.isActive = true
                self?.presentingView?.layoutIfNeeded()
            }
            
            if let outPanel = outPanel {
                outPanel.view.backgroundColor = .clear
                outPanel.leftConstraint?.constant = 0
                
                if let oldBottomPanel = oldBottomPanel, shouldAnimateHeight {
                    oldBottomPanel.middleConstraint?.isActive = false
                }
                
                self?.presentingView?.layoutIfNeeded()
            }
            
        }, completion: { _ in
            outPanel?.view.removeFromSuperview()

            if let oldBottomPanel = oldBottomPanel {
                oldBottomPanel.middleConstraint?.isActive = false
                oldBottomPanel.middleConstraint = nil
            }
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
