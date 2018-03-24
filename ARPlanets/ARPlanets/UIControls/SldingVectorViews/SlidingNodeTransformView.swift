//
//  SlidingNodeTransformView.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-22.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit
import SceneKit

protocol Transformable: class {
    var position: SCNVector3 { get set }
    var rotation: SCNVector4 { get set }
    var scale: SCNVector3 { get set }
    var eulerAngles: SCNVector3 { get set }
}

extension SCNNode: Transformable { }

class SlidingNodeTransformView: UIStackView {
    
    private let positionInput = SlidingVector3View(minValue: -20, maxValue: 20)
    private let rotationInput = SlidingVector4View(minValue: -20, maxValue: 20)
    private let scaleInput = SlidingVector3View(minValue: 5, maxValue: 20)

    weak var transformable: Transformable? = nil
    
    init() {
        super.init(frame: CGRect.zero)
        axis = .vertical
        setupInputs()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for node: SCNNode) {
        transformable = node
        positionInput.vector = node.position
        rotationInput.vector = node.rotation
        scaleInput.vector = node.scale
    }
    
    private func header(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.inputSliderHeader
        return label
    }
    
    private func setupInputs() {
        let positionHeader = header(text: "Position")
        addArrangedSubview(positionHeader)

        positionInput.setPanSpeed(0.04)
        positionInput.delegate = self
        addArrangedSubview(positionInput)
        
        let rotationHeader = header(text: "Rotation")
        rotationInput.delegate = self
        rotationInput.setPanSpeed(0.002)
        addArrangedSubview(rotationHeader)
        addArrangedSubview(rotationInput)
        
        let scaleHeader = header(text: "Scale")
        scaleInput.delegate = self
        scaleInput.setPanSpeed(0.06)
        addArrangedSubview(scaleHeader)
        addArrangedSubview(scaleInput)
    }
}

extension SlidingNodeTransformView: SlidingVector3ViewDelegate {
    func slidingVector3View(_ slidingVector3View: SlidingVector3View, didChangeValues vector: SCNVector3) {
        if slidingVector3View == positionInput {
            transformable?.position = vector
        } else {
            transformable?.scale = vector
        }
    }
}

extension SlidingNodeTransformView: SlidingVector4ViewDelegate {
    func slidingVector4View(_ slidingVector4View: SlidingVector4View, didChangeValues vector: SCNVector4) {
        transformable?.rotation = vector
    }
}
