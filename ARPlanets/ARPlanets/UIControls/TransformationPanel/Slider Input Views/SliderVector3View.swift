//
//  SliderVector3View.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-19.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import SceneKit

protocol SliderVector3ViewDelegate: class {
    func sliderVector3View(_ sliderVector3View: SliderVector3View, didChangeValues vector: SCNVector3)
}

// A SliderInputsView with 3 values, x, y, and z.
class SliderVector3View: SliderInputsView {
    
    var vector = SCNVector3() {
        didSet {
            setValue(vector.x, atIndex: 0)
            setValue(vector.y, atIndex: 1)
            setValue(vector.z, atIndex: 2)
        }
    }
    
    weak var delegate: SliderVector3ViewDelegate? = nil
    
    init(minValue: Float = -Float.greatestFiniteMagnitude,
         maxValue: Float = Float.greatestFiniteMagnitude) {
        super.init(axisLabels: ["X:", "  Y:", "  Z:"], minValue: minValue, maxValue: maxValue)
        viewDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SliderVector3View: SliderInputsViewDelegate {
    func sliderInputView(didChange value: Float, at index: Int) {
        switch index {
        case 0:
            vector.x = value
        case 1:
            vector.y = value
        default:
            vector.z = value
        }
        delegate?.sliderVector3View(self, didChangeValues: vector)
    }
}

