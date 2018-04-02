//
//  PowerPanelTextField.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-30.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

protocol PowerPanelTextFieldDelegate: class {
    func powerPanelTextField(didChangeText text: String?)
}

class PowerPanelTextField: UIView {
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    weak var delegate: PowerPanelTextFieldDelegate?
    
    private let textField = UITextField()
    
    init() {
        super.init(frame: CGRect.zero)
        setupPowerPanelTextField(textField, tintColor: .uiControlColor)
        textField.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PowerPanelTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let editedString = (text! as NSString).replacingCharacters(in: range, with: string)
        delegate?.powerPanelTextField(didChangeText: editedString)
        return true
    }
}
