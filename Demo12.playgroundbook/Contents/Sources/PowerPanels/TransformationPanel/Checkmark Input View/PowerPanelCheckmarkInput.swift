//
//  PowerPanelCheckmarkInput.swift
//  ARPowerPanels
//
//  Created by TSD040 on 2018-03-31.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

class PowerPanelCheckmarkInput: UIStackView {
    
    var isChecked: Bool = true {
        didSet {
            button.isSelected = isChecked
        }
//        get {
//            return checkmark.isChecked
//        }
//        set {
//            checkmark.isChecked = newValue
//        }
    }
    
    private let checkmark = PowerPanelCheckmarkView()
    let button = UIButton()

    init(text: String) {
        super.init(frame: CGRect.zero)
        
        let label = UILabel()
        label.text = text
        addArrangedSubview(label)
        
        button.isSelected = isChecked
        button.setImage(#imageLiteral(resourceName: "checkmarkWhite"), for: .selected)
        button.setImage(#imageLiteral(resourceName: "checkmarkWhite"), for: .highlighted)
        button.backgroundColor = .blue
        button.setupPowerPanelBorder(tintColor: .uiControlColor)
        addArrangedSubview(button)
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonPressed() {
        isChecked = !isChecked
        print("button pressed")
    }
}
