//
//  SidePanelPresentor.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-24.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

private struct PanelContainer {
    let container: UIView
    let rightConstraint: NSLayoutConstraint
    let presentingView: UIView
}

class RightPanelPresenter {
    private var panelContainer: PanelContainer?
    
    func presentFromRight(newPresentedView: UIView, presentingView: UIView, width: CGFloat, insets: UIEdgeInsets) {
        
        let container = UIView()
        container.layer.cornerRadius = 20.0
        container.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        container.clipsToBounds = true
        presentingView.addSubview(container)

        // Looks nice but is too slow
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        container.addSubview(blurEffectView)
//        blurEffectView.constrainEdges(to: container)
        
        let containerWidth = width + insets.left + insets.right
        container.constrainWidth(containerWidth)
        container.constrainTop(to: presentingView)
        
        let containerRightConstraint = container.constrainLeftToRight(of: presentingView)
        
        container.addSubview(newPresentedView)
        newPresentedView.constrainEdges(to: container, insets: insets)
        
        panelContainer = PanelContainer(container: container,
                                             rightConstraint: containerRightConstraint,
                                             presentingView: presentingView)
        
        startPresentation()
    }
    
    private func startPresentation() {
        guard let panelContainer = panelContainer else { return }
        
        panelContainer.presentingView.layoutIfNeeded()

        UIView.animate(withDuration: 0.5, animations: {
            let container = panelContainer.container
//            container.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            panelContainer.rightConstraint.constant = -container.bounds.width
            panelContainer.presentingView.layoutIfNeeded()
        }, completion: { _ in
            print("YO!")
        })
    }
    
    func dismissPresentedView() {
        guard let panelContainer = panelContainer else { return }

        UIView.animate(withDuration: 0.5, animations: {
//            panelContainer.container.backgroundColor = .clear
            panelContainer.rightConstraint.constant = 0
            panelContainer.presentingView.layoutIfNeeded()
        }) { [weak self] _ in
            self?.panelContainer?.container.removeFromSuperview()
            self?.panelContainer = nil
        }
    }
}
