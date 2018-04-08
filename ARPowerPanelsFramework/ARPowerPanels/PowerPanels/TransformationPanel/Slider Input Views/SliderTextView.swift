//
//  SliderTextView.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit

protocol SliderTextViewDelegate: class {
    func sliderTextView(_ sliderTextView: SliderTextView, didChange value: Float)
}

/// A view containing a DecimalTextField where the use can type using the keyboard,
// or pan a finger to scrub through values quickly.
// Takes a minValue, maxValue, stores the current value, and can notify the caller when the value has changed.
class SliderTextView: UIView {

    // MARK: - Variables
    weak var delegate: SliderTextViewDelegate?

    /// Value change per unit panned
    var panSpeed: Float = 1

    var value: Float {
        get {
            return textField.value
        }
        set {
            guard newValue >= minValue && newValue <= maxValue && newValue != value else { return }
            textField.value = newValue
        }
    }
    
    private var originalValue: Float = 0
    private var minValue: Float
    private var maxValue: Float
    
    // MARK: - Private Constants
    private let customTintColor = UIColor.uiControlColor
    private let textField: DecimalTextField
    
    // MARK: - Public
    /// An view that allows the user to change the input either by typing, or by vertically panning the view.
    ///
    /// - Parameters:
    ///   - valueChangePerPanUnit: How much the value is changed when the user pans the view by one unit.
    init(minValue: Float, maxValue: Float) {
        
        textField = DecimalTextField(decimalPlaces: 2)
        textField.minValue = minValue
        textField.maxValue = maxValue
        
        self.minValue = minValue
        self.maxValue = maxValue
        super.init(frame: CGRect.zero)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func setup() {
        
        textField.decimalTextFieldDelegate = self
        textField.accessoryBackgroundColor = customTintColor
        textField.accessoryNormalTextColor = #colorLiteral(red: 0.9073373833, green: 1, blue: 0.9944009735, alpha: 1)
        textField.accessoryHighlightedTextColor = #colorLiteral(red: 0.2576798222, green: 0.6260439845, blue: 0.6919346817, alpha: 1)

        setupPowerPanelTextField(textField, tintColor: customTintColor)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func didPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            originalValue = value
        case .changed, .possible:
            let translation = gestureRecognizer.translation(in: self)
            let yDelta = Float(translation.y) * -1.0 * panSpeed
            let pannedValue = originalValue + yDelta
            
            let snappedValue = pannedValue.snapToValueIfClose(
                snapToValues: [minValue, 0, maxValue],
                withinRange: panSpeed * 8.0)

            value = snappedValue
            delegate?.sliderTextView(self, didChange: value)

        case .cancelled, .failed:
            value = originalValue
            delegate?.sliderTextView(self, didChange: value)

        case .ended:
            break
        }
    }
}

extension SliderTextView: DecimalTextFieldDelegate {
    func decimalTextField(valueDidChange value: Float) {
        self.value = value
        delegate?.sliderTextView(self, didChange: value)
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
