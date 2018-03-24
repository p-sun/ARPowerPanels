//
//  SlidingVector3View.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-19.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit
import SceneKit

protocol SlidingVector3ViewDelegate: class {
    func slidingVector3View(_ slidingVector3View: SlidingVector3View, didChangeValues vector: SCNVector3)
}

// A SlidingInputsView with 3 values, x, y, and z.
class SlidingVector3View: SlidingInputsView {
    
    var vector = SCNVector3() {
        didSet {
            setValue(vector.x, atIndex: 0)
            setValue(vector.y, atIndex: 1)
            setValue(vector.z, atIndex: 2)
        }
    }
    
    weak var delegate: SlidingVector3ViewDelegate? = nil
    
    init(minValue: Float = -Float.greatestFiniteMagnitude,
         maxValue: Float = Float.greatestFiniteMagnitude) {
        super.init(axisLabels: ["x:", "  y:", "  z:"], minValue: minValue, maxValue: maxValue)
        viewDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SlidingVector3View: SlidingInputsViewDelegate {
    func slidingInputView(didChange value: Float, at index: Int) {
        switch index {
        case 0:
            vector.x = value
        case 1:
            vector.y = value
        default:
            vector.z = value
        }
        delegate?.slidingVector3View(self, didChangeValues: vector)
    }
}

