//
//  SliderVector4View.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-23.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import SceneKit

protocol SliderVector4ViewDelegate: class {
    func sliderVector4View(_ sliderVector4View: SliderVector4View, didChangeValues vector: SCNVector4)
}

// A SliderInputsView with 4 values, x, y, z, and w.
class SliderVector4View: SliderInputsView {
    
    var vector = SCNVector4() {
        didSet {
            setValue(vector.x, atIndex: 0)
            setValue(vector.y, atIndex: 1)
            setValue(vector.z, atIndex: 2)
            setValue(vector.w, atIndex: 3)
        }
    }
    
    weak var delegate: SliderVector4ViewDelegate? = nil
    
    init(minValue: Float = -Float.greatestFiniteMagnitude,
         maxValue: Float = Float.greatestFiniteMagnitude) {
        super.init(axisLabels: ["X:", "  Y:", "  Z:", " W:"], minValue: minValue, maxValue: maxValue)
        viewDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SliderVector4View: SliderInputsViewDelegate {
    func sliderInputView(didChange value: Float, at index: Int) {
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
        delegate?.sliderVector4View(self, didChangeValues: vector)
    }
}
