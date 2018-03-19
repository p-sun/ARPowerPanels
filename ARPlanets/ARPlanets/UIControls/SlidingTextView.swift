//
//  SlidingTextView.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit

typealias SlidingInputViewValueDidChange = (_ value: CGFloat) -> Void

class SlidingInputView: UIView {

    // MARK: - Variables
    var minValue = CGFloat.leastNormalMagnitude {
        didSet {
            textField.minValue = minValue
        }
    }
    var maxValue = CGFloat.greatestFiniteMagnitude {
        didSet {
            textField.maxValue = maxValue
        }
    }
    private var value: CGFloat = 0 {
        didSet {
            if textField.value != value {
                textField.value = value
            }
            valueDidChange(value)
        }
    }
    private var originalValue: CGFloat = 0
    
    private var valueDidChange: SlidingInputViewValueDidChange
    
    // MARK: - Private Constants
    private let customTintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    private let valueChangePerPanUnit: CGFloat
    private let textField: DecimalTextField

    // MARK: - Public
    /// An view that allows the user to change the input either by typing, or by vertically panning the view.
    ///
    /// - Parameters:
    ///   - valueChangePerPanUnit: How much the value is changed when the user pans the view by one unit.
    init(valueChangePerPanUnit: CGFloat = 1, valueDidChange: @escaping SlidingInputViewValueDidChange) {
        self.valueDidChange = valueDidChange
        self.valueChangePerPanUnit = valueChangePerPanUnit
        
        self.textField = DecimalTextField(decimalPlaces: 2)
        
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func setup() {
        backgroundColor = .white
        layer.borderColor = customTintColor.cgColor
        layer.borderWidth = 4
        layer.cornerRadius = 8
        
        textField.decimalTextFieldDelegate = self
        
        textField.tintColor = customTintColor
        textField.accessoryBackgroundColor = customTintColor
        textField.accessoryNormalTextColor = #colorLiteral(red: 0.9073373833, green: 1, blue: 0.9944009735, alpha: 1)
        textField.accessoryHighlightedTextColor = #colorLiteral(red: 0.2576798222, green: 0.6260439845, blue: 0.6919346817, alpha: 1)
        
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.value = 0
        addSubview(textField)
        textField.constrainEdges(to: self, insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    func setValue(_ value: CGFloat) {
        func isCurrentValueCloseTo(targetValue: CGFloat, currentValue: CGFloat) -> Bool {
            let range = valueChangePerPanUnit * 30.0
            return currentValue >= targetValue - range && currentValue <= targetValue + range
        }
        
        if isCurrentValueCloseTo(targetValue: 0, currentValue: value) {
            self.value = 0
        } else if isCurrentValueCloseTo(targetValue: minValue, currentValue: value) {
            self.value = minValue
        } else if isCurrentValueCloseTo(targetValue: maxValue, currentValue: value) {
            self.value = maxValue
        } else if value >= minValue && value <= maxValue {
            self.value = value
        }
    }
    
    @objc private func didPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            originalValue = value
        case .changed, .possible:
            let translation = gestureRecognizer.translation(in: self)
            let yDelta = translation.y * -1.0 * valueChangePerPanUnit
            setValue(originalValue + yDelta)
        case .cancelled, .failed:
            setValue(originalValue)
        case .ended:
            break
        }
    }
}

extension SlidingInputView: DecimalTextFieldDelegate {
    func decimalTextField(valueDidChange value: CGFloat) {
        setValue(value)
    }
}
