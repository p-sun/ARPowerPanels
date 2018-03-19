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
            // TODO
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let textField = DecimalTextField(decimalPlaces: 3)
        textField.value = 0
        addSubview(textField)
        textField.constrainEdges(to: self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func didPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        print(gestureRecognizer.translation(in: self))
    }
}
