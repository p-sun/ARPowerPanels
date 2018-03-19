//
//  DecimalMinusTextField.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-18.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

class DecimalTextField: UITextField {
    
    private let decimalPlaces: Int
    private let maximumDigits = 12
    
    var value: Double = 0.0 {
        didSet {
            text = valueString
        }
    }
    
    private var valueString: String {
        return String(format: "%.\(decimalPlaces)f", value)
    }
    
    init(decimalPlaces: Int) {
        self.decimalPlaces = decimalPlaces
        super.init(frame: CGRect.zero)
        keyboardType = .numberPad
        autocorrectionType = .no
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        inputAccessoryView = minusAndDoneButtons()
    }
    
    private func minusAndDoneButtons() -> UIView {
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: superview!.frame.size.width, height: 44))
        backgroundView.backgroundColor = #colorLiteral(red: 0.5580514931, green: 0.9646365219, blue: 0.7657005421, alpha: 1)
        
        let stackView = buttonsStackView()
        backgroundView.addSubview(stackView)
        stackView.constrainEdges(to: backgroundView)
        
        return backgroundView
    }
    
    private func buttonsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        
        let minusButton = DecimalTextField.accessoryButton(title: "—")
        minusButton.addTarget(self, action: #selector(minusPressed), for: .touchUpInside)
        stackView.addArrangedSubview(minusButton)
        
        let doneButton = DecimalTextField.accessoryButton(title: "Done")
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        stackView.addArrangedSubview(doneButton)
        
        return stackView
    }
    
    private static func accessoryButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitleColor(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.6307376027, green: 0.8862745166, blue: 0.8431658146, alpha: 1), for: .highlighted)
        button.setTitle(title, for: .normal)
        return button
    }
    
    @objc private func minusPressed(_ sender: UIButton!) {
        value = value * -1.0
    }
    
    @objc func donePressed() {
        resignFirstResponder()
    }
}

extension DecimalTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let editedString = (text! as NSString).replacingCharacters(in: range, with: string)

        if let newValue = editedString.double(decimalPlaces: decimalPlaces, maximumDigits: maximumDigits) {
            value = newValue
        }
        return false
    }
}

private extension String {
    func double(decimalPlaces: Int, maximumDigits: Int) -> Double? {
        // Remove occurences of "."
        let periodRemovedString = replacingOccurrences(of: ".", with: "")
        guard periodRemovedString.count < maximumDigits else {
            return nil
        }
        
        // Add "." back to the specified number of decimal places
        let newValueString: String
        if periodRemovedString.count > decimalPlaces {
            let length = periodRemovedString.count
            let prefix = periodRemovedString.prefix(length - decimalPlaces)
            let suffix = periodRemovedString.suffix(decimalPlaces)
            newValueString = prefix + "." + suffix
        } else {
            newValueString = "0." + periodRemovedString
        }
        
        // Convert the String to Double
        if let newValue = Double(newValueString) {
            return newValue
        }
        return nil
    }
}
