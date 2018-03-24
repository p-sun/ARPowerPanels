//
//  SlidingVector4View.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-23.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit
import SceneKit

protocol SlidingVector4ViewDelegate: class {
    func slidingVector4View(didChangeValues vector: SCNVector4)
}

// A SlidingInputsView with 3 values, x, y, and z.
class SlidingVector4View: SlidingInputsView {
    
    var vector = SCNVector4()
    
    weak var delegate: SlidingVector4ViewDelegate? = nil
    
    init(minValue: Float, maxValue: Float) {
        super.init(axisLabels: ["x:", "  y:", "  z:", " w:"], minValue: minValue, maxValue: maxValue)
        viewDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SlidingVector4View: SlidingInputsViewDelegate {
    func slidingInputView(didChange value: Float, at index: Int) {
        switch index {
        case 0:
            vector.x = value
        case 1:
            vector.y = value
        case 2:
            vector.z = value
        default:
            vector.w = value
        }
        delegate?.slidingVector4View(didChangeValues: vector)
    }
}
