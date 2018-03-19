//
//  SlidingTextView.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit

class SlidingInputView: UIView {
    
    var value: CGFloat = 0 {
        didSet {
            textField.value = value
        }
    }
    private var originalValue: CGFloat = 0

    private let valueChangePerPanUnit: CGFloat
    private let textField: DecimalTextField

    /// An view that allows the user to change the input either by typing, or by vertically panning the view.
    ///
    /// - Parameters:
    ///   - valueChangePerPanUnit: How much the value is changed when the user pans the view by one unit.
    init(valueChangePerPanUnit: CGFloat = 1) {
        self.valueChangePerPanUnit = valueChangePerPanUnit
        self.textField = DecimalTextField(decimalPlaces: 2)
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        textField.value = 0
        addSubview(textField)
        textField.constrainEdges(to: self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func didPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            originalValue = value
        case .changed, .possible:
            let translation = gestureRecognizer.translation(in: self)
            let yDelta = translation.y * -1.0 * valueChangePerPanUnit
            value = originalValue + yDelta
            print(gestureRecognizer.translation(in: self))
        case .cancelled, .failed:
            value = originalValue
        case .ended:
            break
        }
    }
}
