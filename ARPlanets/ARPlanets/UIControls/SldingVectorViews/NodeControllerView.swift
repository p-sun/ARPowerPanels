//
//  NodeControllerView.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-22.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit
import SceneKit

private protocol Transformable: class {
    var position: SCNVector3 { get set }
    var rotation: SCNVector4 { get set }
    var scale: SCNVector3 { get set }
    var eulerAngles: SCNVector3 { get set }
}

extension SCNNode: Transformable { }

class NodeControllerView: UIStackView {
    
    // MARK: - Variables - Initialized externally
    weak private var transformable: Transformable? = nil
    private let controlTypes: [NodeControlType]
    
    // MARK: - Variables - Views
    private lazy var positionInput = SlidingVector3View()
    private lazy var quaternionRotationInput = SlidingVector4View()
    private lazy var eulerRotationInput = SlidingVector3View()
    private lazy var scaleInput = SlidingVector3View(minValue: 0.3)
    
    // MARK: - Public
    init(controlTypes: [NodeControlType]) {
        self.controlTypes = controlTypes
        
        super.init(frame: CGRect.zero)
        axis = .vertical
        
        for controlType in controlTypes {
            setupInputView(for: controlType)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func controlNode(_ node: SCNNode) {
        transformable = node
        
        for controlType in controlTypes {
            updateInput(for: controlType)
        }
    }
    
    // MARK: - Private
    private func setupInputView(for controlType: NodeControlType) {
        addArrangedSubview(header(for: controlType))
        
        switch controlType {
        case .position:
            positionInput.setPanSpeed(0.04)
            positionInput.delegate = self
            addArrangedSubview(positionInput)
            
        case .quaterionRotation:
            quaternionRotationInput.delegate = self
            quaternionRotationInput.setPanSpeed(0.007)
            addArrangedSubview(quaternionRotationInput)
            
        case .eulerRotation:
            eulerRotationInput.delegate = self
            eulerRotationInput.setPanSpeed(0.007)
            addArrangedSubview(eulerRotationInput)
            
        case .scale:
            scaleInput.delegate = self
            scaleInput.setPanSpeed(0.06)
            addArrangedSubview(scaleInput)
        }
    }
    
    private func header(for type: NodeControlType) -> UILabel {
        let label = UILabel()
        label.text = type.displayName
        label.font = UIFont.inputSliderHeader
        return label
    }
    
    private func updateInput(for controlType: NodeControlType) {
        
        guard let transformable = transformable, controlTypes.contains(controlType) else { return }
        
        switch controlType {
        case .position:
            positionInput.vector = transformable.position
        case .quaterionRotation:
            quaternionRotationInput.vector = transformable.rotation
        case .eulerRotation:
            eulerRotationInput.vector = transformable.eulerAngles
        case .scale:
            scaleInput.vector = transformable.scale
        }
    }
}

extension NodeControllerView: SlidingVector3ViewDelegate {
    func slidingVector3View(_ slidingVector3View: SlidingVector3View, didChangeValues vector: SCNVector3) {
        if controlTypes.contains(.position) &&
            slidingVector3View == positionInput {
            transformable?.position = vector
            
        } else if controlTypes.contains(.eulerRotation) &&
            slidingVector3View == eulerRotationInput {
            transformable?.eulerAngles = vector
            
            updateInput(for: .quaterionRotation)
            
        } else if controlTypes.contains(.scale) &&
            slidingVector3View == scaleInput {
            transformable?.scale = vector
            
        } else {
            fatalError("Not implemented")
        }
    }
}

extension NodeControllerView: SlidingVector4ViewDelegate {
    func slidingVector4View(_ slidingVector4View: SlidingVector4View, didChangeValues vector: SCNVector4) {
        transformable?.rotation = vector

        updateInput(for: .eulerRotation)
    }
}
