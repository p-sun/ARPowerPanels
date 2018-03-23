//
//  SlidingTextView.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit

typealias SlidingTextViewValueDidChange = (_ value: Float) -> Void

/// A view containing a DecimalTextField where the use can type using the keyboard,
// or pan a finger to scrub through values quickly.
// Takes a minValue, maxValue, stores the current value, and can notify the caller when the value has changed.
class SlidingTextView: UIView {

    // MARK: - Variables
    private var value: Float = 0 {
        didSet {
            if textField.value != value {
                textField.value = value
            }
            valueDidChange(value)
        }
    }
    private var originalValue: Float = 0
    private var minValue: Float
    private var maxValue: Float
    
    private var valueDidChange: SlidingTextViewValueDidChange
    
    // MARK: - Private Constants
    private let customTintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    private let textField: DecimalTextField

    // MARK: - Public
    /// An view that allows the user to change the input either by typing, or by vertically panning the view.
    ///
    /// - Parameters:
    ///   - valueChangePerPanUnit: How much the value is changed when the user pans the view by one unit.
    init(minValue: Float, maxValue: Float, valueDidChange: @escaping SlidingTextViewValueDidChange) {
        
        textField = DecimalTextField(decimalPlaces: 2)
        textField.minValue = minValue
        textField.maxValue = maxValue
        
        self.minValue = minValue
        self.maxValue = maxValue
        self.valueDidChange = valueDidChange
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
        
        textField.font = UIFont.boldSystemFont(ofSize: 19)
        textField.value = 0
        addSubview(textField)
        textField.constrainEdges(to: self, insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    func setValue(_ value: Float) {
        if value >= minValue && value <= maxValue {
            self.value = value
        }
    }
    
    @objc private func didPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            originalValue = value
        case .changed, .possible:
            let valueChangePerUnitPanned = (maxValue - minValue) / 800
            let translation = gestureRecognizer.translation(in: self)
            let yDelta = Float(translation.y) * -1.0 * valueChangePerUnitPanned
            let pannedValue = originalValue + yDelta
            
            let snappedValue = pannedValue.snapToValueIfClose(
                snapToValues: [minValue, 0, maxValue],
                withinRange: valueChangePerUnitPanned * 10.0)
            
            setValue(snappedValue)
        case .cancelled, .failed:
            setValue(originalValue)
        case .ended:
            break
        }
    }
}

extension SlidingTextView: DecimalTextFieldDelegate {
    func decimalTextField(valueDidChange value: Float) {
        setValue(value)
    }
}

private extension Float {
    func snapToValueIfClose(snapToValues: [Float], withinRange: Float) -> Float {
        func isCurrentValueCloseTo(targetValue: Float) -> Bool {
            let min = targetValue - withinRange
            let max = targetValue + withinRange
            return self >= min && self <= max
        }
        
        for targetValue in snapToValues {
            if isCurrentValueCloseTo(targetValue: targetValue) {
                return targetValue
            }
        }
        
        return self
    }
}
