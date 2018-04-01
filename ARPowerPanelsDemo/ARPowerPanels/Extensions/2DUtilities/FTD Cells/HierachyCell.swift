//
//  HierachyCell.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-28.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit
import SceneKit

typealias HierachyCell = HostCell<HierachyView, HierachyState, LayoutMarginsTableItemLayout>

enum ExpandableState {
    case isNotExpanded, isExpanded, isNotExpandable
    
    func arrow() -> String {
        switch self {
        case .isNotExpanded:
            return "▶"
        case .isExpanded:
            return "▼"
        case .isNotExpandable:
            return ""
        }
    }
}

struct HierachyState: StateType {
    typealias View = HierachyView
    
    private static let insetPerLevel: CGFloat = 20

    let node: SCNNode
    let level: Int
    let expandableState: ExpandableState
    let text: String?
    let font: UIFont
    let color: UIColor
    let expandButtonPressed: () -> Void

    init(node: SCNNode, level: Int, expandableState: ExpandableState, text: String?, font: UIFont, color: UIColor, expandButtonPressed: @escaping () -> Void) {
        self.node = node
        self.level = level
        self.expandableState = expandableState
        self.text = text
        self.font = font
        self.color = color
        self.expandButtonPressed = expandButtonPressed
    }
    
    static func updateView(_ view: HierachyView, state: HierachyState?) {
        guard let state = state else {
            return
        }

        view.leftConstraint.constant = insetPerLevel * CGFloat(state.level)
        view.arrowButton.setTitle(state.expandableState.arrow(), for: .normal)
        view.labelView.text = state.text
        view.labelView.font = state.font
        view.labelView.textColor = state.color
        view.expandButtonPressed = state.expandButtonPressed
    }
}

class HierachyView: UIView {
    
    fileprivate var leftConstraint: NSLayoutConstraint!
    fileprivate let arrowButton = UIButton()
    fileprivate let labelView = UILabel()
    
    fileprivate var expandButtonPressed: (() -> Void)?

    init() {
        super.init(frame: CGRect.zero)

        let stackView = UIStackView()
        addSubview(stackView)
        stackView.constrainTop(to: self)
        stackView.constrainBottom(to: self, priority: .init(998))
        leftConstraint = stackView.constrainLeft(to: self)
        stackView.constrainRight(to: self, priority: .init(998))
        
        arrowButton.setTitleColor(.white, for: .normal)
        arrowButton.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        arrowButton.addTarget(self, action: #selector(expandButtonAction), for: .touchUpInside)
        arrowButton.constrainWidth(44)
        stackView.addArrangedSubview(arrowButton)
        
        stackView.addArrangedSubview(labelView)
        labelView.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func expandButtonAction() {
        expandButtonPressed?()
    }
}

extension HierachyState: Equatable {
    public static func ==(lhs: HierachyState, rhs: HierachyState) -> Bool {
        var isEqual = true
        isEqual = isEqual && lhs.node == rhs.node
        isEqual = isEqual && lhs.level == rhs.level
        isEqual = isEqual && lhs.expandableState == rhs.expandableState
        isEqual = isEqual && lhs.text == rhs.text
        isEqual = isEqual && lhs.font == rhs.font
        isEqual = isEqual && lhs.color == rhs.color
        return isEqual
    }
}

extension SCNNode {
    var memoryAddress: String {
        return String(format: "%p", unsafeBitCast(self, to: Int.self)) // i.e. 0x1c41f5100
    }
}
