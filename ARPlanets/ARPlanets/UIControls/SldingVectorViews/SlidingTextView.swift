//
//  SlidingTextView.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit

protocol SlidingTextViewDelegate: class {
    func slidingTextView(_ slidingTextView: SlidingTextView, didChange value: Float)
}

/// A view containing a DecimalTextField where the use can type using the keyboard,
// or pan a finger to scrub through values quickly.
// Takes a minValue, maxValue, stores the current value, and can notify the caller when the value has changed.
class SlidingTextView: UIView {

    // MARK: - Variables
    weak var delegate: SlidingTextViewDelegate?

    /// Value change per unit panned
    var panSpeed: Float = 1 {
        didSet {
            print("set pan speed \(panSpeed)")
        }
    }

    var value: Float {
        get {
            return textField.value
        }
        set {
            guard newValue >= minValue && newValue <= maxValue && newValue != value else { return }
            print("SlidingTextView setting new value \(newValue)")
            textField.value = newValue
        }
    }
    
    private var originalValue: Float = 0
    private var minValue: Float
    private var maxValue: Float
    
    // MARK: - Private Constants
    private let customTintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
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
        backgroundColor = .white
        layer.borderColor = customTintColor.cgColor
        layer.borderWidth = 4
        layer.cornerRadius = 8
        
        textField.decimalTextFieldDelegate = self
        
        textField.tintColor = customTintColor
        textField.accessoryBackgroundColor = customTintColor
        textField.accessoryNormalTextColor = #colorLiteral(red: 0.9073373833, green: 1, blue: 0.9944009735, alpha: 1)
        textField.accessoryHighlightedTextColor = #colorLiteral(red: 0.2576798222, green: 0.6260439845, blue: 0.6919346817, alpha: 1)
        
        textField.font = UIFont.inputSlider
        addSubview(textField)
        textField.constrainEdges(to: self, insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
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
                withinRange: panSpeed * 10.0)

            print("snap \(snappedValue) from \(pannedValue) withinRange +-\(panSpeed * 10.0) panspeed \(panSpeed)")

            value = snappedValue
            delegate?.slidingTextView(self, didChange: value)

        case .cancelled, .failed:
            value = originalValue
            delegate?.slidingTextView(self, didChange: value)

        case .ended:
            break
        }
    }
}

extension SlidingTextView: DecimalTextFieldDelegate {
    func decimalTextField(valueDidChange value: Float) {
        self.value = value
        delegate?.slidingTextView(self, didChange: value)
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