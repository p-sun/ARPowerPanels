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
            button.backgroundColor  = newValue ? .uiControlColor : .white
        }
    }
    
    weak var delegate: PowerPanelCheckmarkInputDelegate?

    private let button = UIButton()

    init(text: String) {
        super.init(frame: CGRect.zero)
                
        self.axis = .horizontal
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.inputSliderHeader
        label.textColor = .white
        addArrangedSubview(label)
        
        let buttonParent = UIView()
        buttonParent.constrainAspectRatio(to: CGSize(width: 1, height: 1))
        addArrangedSubview(buttonParent)
        
        button.isSelected = isChecked
        let checkMarkWhiteImage = ImageAssets.checkmarkWhite.image()
        button.setImage(checkMarkWhiteImage, for: .selected)
        button.setImage(checkMarkWhiteImage, for: .highlighted)
        button.setupPowerPanelBorder(tintColor: .uiControlColor)
        buttonParent.addSubview(button)
        button.constrainEdges(to: buttonParent, insets: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        
        isChecked = false
        
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
