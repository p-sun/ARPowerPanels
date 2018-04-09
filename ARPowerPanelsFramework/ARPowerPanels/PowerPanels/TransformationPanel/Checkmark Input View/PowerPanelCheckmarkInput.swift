//
//  PowerPanelCheckmarkInput.swift
//  ARPowerPanels
//
//  Created by TSD040 on 2018-03-31.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

protocol PowerPanelCheckmarkInputDelegate: class {
    func powerPanelCheckmarkInput(_ checkMarkInput: PowerPanelCheckmarkInput, isCheckedDidChange isChecked: Bool)
}

class PowerPanelCheckmarkInput: UIStackView {
    
    var isChecked: Bool {
        get {
            return button.isSelected
        }
        set {
            button.isSelected = newValue
        }
    }
    
    weak var delegate: PowerPanelCheckmarkInputDelegate?

    private let button = UIButton()

    init(text: String) {
        super.init(frame: CGRect.zero)
        
        isChecked = true
        
        self.axis = .horizontal
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.inputSliderHeader
        label.textColor = .white
        addArrangedSubview(label)
        
        button.isSelected = isChecked
        button.setImage(#imageLiteral(resourceName: "checkmarkWhite"), for: .selected)
        button.setImage(#imageLiteral(resourceName: "checkmarkWhite"), for: .highlighted)
        button.setupPowerPanelBorder(tintColor: .uiControlColor)
        button.constrainAspectRatio(to: CGSize(width: 1, height: 1))
        button.backgroundColor = UIColor.uiControlColor
        addArrangedSubview(button)
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonPressed() {
        isChecked = !isChecked
        button.isSelected = isChecked
        delegate?.powerPanelCheckmarkInput(self, isCheckedDidChange: isChecked)
    }
}
