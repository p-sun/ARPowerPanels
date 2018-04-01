//
//  MenuStack.swift
//  RoundedButtonMenus
//
//  Created by TSD040 on 2018-03-26.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit

class MenuStackItem {
    let name: String
    var isSelected: Bool = false
    
    init(name: String) {
        self.name = name
    }
}

protocol MenuStackDelegate: class {
    func menuStack(_ menuStack: MenuStack, didSelectAtIndex index: Int)
}

class MenuStack: UIScrollView {
    
    weak var menuStackDelegate: MenuStackDelegate?
    
    private let stackView = UIStackView()
    
    init(axis: UILayoutConstraintAxis) {
        super.init(frame: CGRect.zero)
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        stackView.spacing = 15
        stackView.axis = axis
        self.addSubview(stackView)
        stackView.constrainEdges(to: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(menuItems: [MenuStackItem]) {
        for arrangeSubview in stackView.arrangedSubviews {
            arrangeSubview.removeFromSuperview()
        }
        
        for (index, menuItem) in menuItems.enumerated() {
            let button = RoundedButton()
            button.tag = index
            button.setTitle(menuItem.name)
            button.isSelected = menuItem.isSelected
            button.delegate = self
            stackView.addArrangedSubview(button)
        }
    }    
}

extension MenuStack: RoundedButtonDelegate {
    func roundedButton(didTap button: RoundedButton) {
        menuStackDelegate?.menuStack(self, didSelectAtIndex: button.tag)
    }
}
