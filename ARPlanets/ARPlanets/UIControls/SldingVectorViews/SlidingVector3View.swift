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
    func slidingVector3View(didChangeValues vector: SCNVector3)
}

class SlidingVector3View: SlidingInputsView {
    
    var vector = SCNVector3()
    
    weak var delegate: SlidingVector3ViewDelegate? = nil
    
    init(minValue: Float, maxValue: Float) {
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
        delegate?.slidingVector3View(didChangeValues: vector)
    }
}

