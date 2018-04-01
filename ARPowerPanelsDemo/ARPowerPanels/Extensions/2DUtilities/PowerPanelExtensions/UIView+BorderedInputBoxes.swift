//
//  UIView+BorderedInputBoxes.swift
//  ARPowerPanels
//
//  Created by TSD040 on 2018-03-31.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

extension UIView {
    static var cornerRadius: CGFloat = 20.0
    
    func addCornerRadius() {
        self.layer.cornerRadius = UIView.cornerRadius
        self.layer.masksToBounds = true
    }
    
    func setupPowerPanelTextField(_ textField: UITextField, tintColor: UIColor) {
        setupPowerPanelBorder(tintColor: tintColor)
        
        textField.tintColor = tintColor
        textField.font = UIFont.inputSlider
        addSubview(textField)
        textField.constrainEdges(to: self, insets: UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6))
    }
    
    func setupPowerPanelBorder(tintColor: UIColor) {
        backgroundColor = .white
        layer.borderColor = tintColor.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 8
    }
}
