//
//  DecimalMinusTextField.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit

protocol DecimalTextFieldDelegate: class {
    func decimalTextField(valueDidChange value: Float)
}

/// A text field that displays a Float to the specified number of decimal digits,
/// and allows the user to enter values with the keyboard.
/// Allows for user to set:
///       - Color for accessory buttons on the keyboard
///       - min and max values
///       - maximum # of digits
///            - attempts to set or type a value beyond the min or max values will be ignored
///       - number of decimal places
///            - values set are rounded to the specified number of decimal places.
///       - keyboard accessory buttons
///            - zero sets the text to 0, or the min value
///            - minus mulplies the value by -1, if min value < 0
class DecimalTextField: UITextField {
    
    private var value: Float = 0.0 {
        didSet {
            guard oldValue != value else { return }
            print("textField value \(value) to string \(valueString)")
            
            if let roundedValue = Float(valueString), roundedValue != value {
                print("rounded value \(roundedValue)")
                value = roundedValue
            } else {
                text = valueString
                decimalTextFieldDelegate?.decimalTextField(valueDidChange: value)
            }
        }
    }
    
    var minValue = Float.leastNormalMagnitude
    var maxValue = Float.greatestFiniteMagnitude
    
    var accessoryBackgroundColor = UIColor.lightGray
    var accessoryNormalTextColor = UIColor.white
    var accessoryHighlightedTextColor = UIColor.darkGray
    
    weak var decimalTextFieldDelegate: DecimalTextFieldDelegate?
    
    private let decimalPlaces: Int
    private let maximumDigits = 10

    private var valueString: String {
        return String(format: "%.\(decimalPlaces)f", value)
    }

    init(decimalPlaces: Int) {
        self.decimalPlaces = decimalPlaces
        
        super.init(frame: CGRect.zero)
        keyboardType = .numberPad
        autocorrectionType = .no
        textAlignment = .right
        text = valueString
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        inputAccessoryView = minusAndDoneButtons()
    }
    
    func setValue(_ value: Float) {
        if value >= minValue && value <= maxValue {
            self.value = value
        }
    }
    
    private func minusAndDoneButtons() -> UIView {
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: superview!.frame.size.width, height: 44))
        backgroundView.backgroundColor = accessoryBackgroundColor
        
        let stackView = buttonsStackView()
        backgroundView.addSubview(stackView)
        stackView.constrainEdges(to: backgroundView)
        
        return backgroundView
    }
    
    private func buttonsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        
        let minusButton = accessoryButton(title: "—")
        minusButton.titleLabel?.font = UIFont.inputSlider
        minusButton.addTarget(self, action: #selector(minusPressed), for: .touchUpInside)
        stackView.addArrangedSubview(minusButton)
        
        let zeroButton = accessoryButton(title: "0")
        zeroButton.titleLabel?.font = UIFont.inputSlider
        zeroButton.addTarget(self, action: #selector(zeroPressed), for: .touchUpInside)
        stackView.addArrangedSubview(zeroButton)
        
        let doneButton = accessoryButton(title: "Done")
        doneButton.titleLabel?.font = UIFont.inputSlider
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        stackView.addArrangedSubview(doneButton)
        
        return stackView
    }
    
    private func accessoryButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitleColor(accessoryNormalTextColor, for: .normal)
        button.setTitleColor(accessoryHighlightedTextColor, for: .highlighted)
        button.setTitle(title, for: .normal)
        return button
    }
    
    @objc private func minusPressed(_ sender: UIButton!) {
        guard minValue < 0 else { return }
        value = value * -1.0
    }
    
    @objc private func zeroPressed(_ sender: UIButton!) {
        value = max(0.0, minValue)
        resignFirstResponder()
    }
    
    @objc func donePressed() {
        resignFirstResponder()
    }
}

extension DecimalTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let editedString = (text! as NSString).replacingCharacters(in: range, with: string)

        if let newValue = editedString.cgFloat(decimalPlaces: decimalPlaces, maximumDigits: maximumDigits),
            newValue >= minValue, newValue <= maxValue {
            value = newValue
        }
        return false
    }
}

private extension String {
    func cgFloat(decimalPlaces: Int, maximumDigits: Int) -> Float? {
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
        
        // Convert the String to Float
        if let newFloat = Float(newValueString) {
            return Float(newFloat)
        }
        return nil
    }
}
