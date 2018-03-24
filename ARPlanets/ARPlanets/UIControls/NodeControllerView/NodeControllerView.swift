//
//  NodeControllerView.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-22.
//  Copyright © 2018 Paige Sun. All rights reserved.
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
    private lazy var positionInput = SliderVector3View()
    private lazy var quaternionRotationInput = SliderVector4View()
    private lazy var eulerRotationInput = SliderVector3View()
    private lazy var scaleInput = SliderVector3View(minValue: 0.3)
    
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

extension NodeControllerView: SliderVector3ViewDelegate {
    func sliderVector3View(_ sliderVector3View: SliderVector3View, didChangeValues vector: SCNVector3) {
        if controlTypes.contains(.position) &&
            sliderVector3View == positionInput {
            transformable?.position = vector
            
        } else if controlTypes.contains(.eulerRotation) &&
            sliderVector3View == eulerRotationInput {
            transformable?.eulerAngles = vector
            
            updateInput(for: .quaterionRotation)
            
        } else if controlTypes.contains(.scale) &&
            sliderVector3View == scaleInput {
            transformable?.scale = vector
            
        } else {
            fatalError("Not implemented")
        }
    }
}

extension NodeControllerView: SliderVector4ViewDelegate {
    func sliderVector4View(_ sliderVector4View: SliderVector4View, didChangeValues vector: SCNVector4) {
        transformable?.rotation = vector

        updateInput(for: .eulerRotation)
    }
}
