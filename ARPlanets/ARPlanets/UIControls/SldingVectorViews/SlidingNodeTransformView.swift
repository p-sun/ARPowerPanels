//
//  SlidingNodeTransformView.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-22.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

class SlidingNodeTransformView: UIStackView {
    
    let positionInput = SlidingVector3View(minValue: -200, maxValue: 200)
    let rotationInput = SlidingVector4View(minValue: -200, maxValue: 200)
    let scaleInput = SlidingVector3View(minValue: -200, maxValue: 200)

    init() {
        super.init(frame: CGRect.zero)
        axis = .vertical
        
        let positionHeader = header(text: "Position")
        addArrangedSubview(positionHeader)
        addArrangedSubview(positionInput)
        
        let rotationHeader = header(text: "Rotation")
        addArrangedSubview(rotationHeader)
        addArrangedSubview(rotationInput)
        
        let scaleHeader = header(text: "Scale")
        addArrangedSubview(scaleHeader)
        addArrangedSubview(scaleInput)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func header(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.inputSliderHeader
        return label
    }
}


