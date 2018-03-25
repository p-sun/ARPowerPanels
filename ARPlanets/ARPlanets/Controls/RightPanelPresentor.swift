//
//  SidePanelPresentor.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-24.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

private class PanelContainer {
    let container: UIView
    let rightConstraint: NSLayoutConstraint
    let presentingView: UIView
    var heightConstraint: NSLayoutConstraint!
    
    init(container: UIView, rightConstraint: NSLayoutConstraint, presentingView: UIView) {
        self.container = container
        self.rightConstraint = rightConstraint
        self.presentingView = presentingView
    }
}

class RightPanelPresenter {
    
    private enum PresentationState {
        case isHidden, onTopPanel, onBottomPanel
    }
    
    private var topPanelContainer: PanelContainer?
    private var bottomPanelContainer: PanelContainer?

    
    // If we have AR as main, can present the scene
    // If we have scene as main, can present the AR view
    
    // If there are two, replace the bottom one
    // If we only have top, present the bottom
    // If we only have bottom, present the top
    // If we have none, present the top
    func togglePanel(newPresentedView: UIView, presentingView: UIView, width: CGFloat) {
        let state = presentationState(for: newPresentedView)
        
        switch state {
        case .isHidden:
            if topPanelContainer == nil {
                presentFromRight(newPresentedView: newPresentedView, presentingView: presentingView, width: width, isTopContainer: true)
            } else {
                presentFromRight(newPresentedView: newPresentedView, presentingView: presentingView, width: width, isTopContainer: false)
            }
        case .onTopPanel:
            dismissTopContainer()
        case .onBottomPanel:
            dismissBottomContainer()
        }
    }
    
    private func presentationState(for targetView: UIView) -> PresentationState {
        if topPanelContainer?.container.subviews.first == targetView {
            return .onTopPanel
        } else if bottomPanelContainer?.container.subviews.first == targetView {
            return .onBottomPanel
        } else {
            return .isHidden
        }
    }
    
    private func presentFromRight(newPresentedView: UIView, presentingView: UIView, width: CGFloat, isTopContainer: Bool) {
        
        let container = UIView()
        container.layer.cornerRadius = 20.0
        container.backgroundColor = UIColor.white.withAlphaComponent(1)
        container.clipsToBounds = true
        presentingView.addSubview(container)

        // Looks nice but is too slow
        //        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        //        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //        container.addSubview(blurEffectView)
        //        blurEffectView.constrainEdges(to: container)
        
        let insets = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        let containerWidth = width + insets.left + insets.right
        container.constrainWidth(containerWidth)
        
        let containerRightConstraint = container.constrainLeftToRight(of: presentingView)
        
        container.addSubview(newPresentedView)
        newPresentedView.constrainEdges(to: container, insets: insets)
        
        if isTopContainer {

            container.constrainTop(to: presentingView)
            
            topPanelContainer = PanelContainer(
                container: container,
                rightConstraint: containerRightConstraint,
                presentingView: presentingView)

        } else {
            
            container.constrainBottom(to: presentingView)
            
            bottomPanelContainer = PanelContainer(
                container: container,
                rightConstraint: containerRightConstraint,
                presentingView: presentingView)
        }
        
        startPresentation(isTopContainer: isTopContainer, containerWidth: width)
    }
    
    private func startPresentation(isTopContainer: Bool, containerWidth: CGFloat) {
        
        let panelContainer = isTopContainer ? topPanelContainer! : bottomPanelContainer!
        
        // Either constrain the center of the bottom & top containers together
        // OR constrain the height of the presented container
        if let topContainer = topPanelContainer, let bottomContainer = bottomPanelContainer {
            topContainer.container.constrainBottomToTop(of: bottomContainer.container, offset: -20)
            panelContainer.heightConstraint = panelContainer.container.constrainHeight(0, relation: .equalOrGreater, priority: .defaultLow)
        } else {
            panelContainer.heightConstraint = panelContainer.container.constrainHeight(containerWidth, relation: .equalOrGreater, priority: .defaultLow)
        }
        
        panelContainer.presentingView.layoutIfNeeded()

        UIView.animate(withDuration: 0.5, animations: {
            let container = panelContainer.container
            container.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            panelContainer.rightConstraint.constant = -container.bounds.width
            panelContainer.presentingView.layoutIfNeeded()
        })
    }
    
    func dismissTopContainer() {
        guard let topPanelContainer = topPanelContainer else { return }

        UIView.animate(withDuration: 0.5, animations: {
            topPanelContainer.container.backgroundColor = .clear
            topPanelContainer.rightConstraint.constant = 0
            topPanelContainer.presentingView.layoutIfNeeded()
        }) { [weak self] _ in
            
            if let bottomContainer = self?.bottomPanelContainer {
                bottomContainer.heightConstraint?.constant = bottomContainer.container.bounds.height
            }
            
            self?.topPanelContainer?.container.removeFromSuperview()
            self?.topPanelContainer = nil
        }
    }
    
    func dismissBottomContainer() {
        guard let bottomPanelContainer = bottomPanelContainer else { return }
        
        UIView.animate(withDuration: 0.5, animations: {
            bottomPanelContainer.container.backgroundColor = .clear
            bottomPanelContainer.rightConstraint.constant = 0
            bottomPanelContainer.presentingView.layoutIfNeeded()
            
        }) { [weak self] _ in
            
            if let topContainer = self?.topPanelContainer {
                topContainer.heightConstraint?.constant = topContainer.container.bounds.height
            }
            
            self?.bottomPanelContainer?.container.removeFromSuperview()
            self?.bottomPanelContainer = nil
        }
    }
}
