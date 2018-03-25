//
//  TransformationPanel.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-22.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import SceneKit

class TransformationPanel: UIStackView {
    
    // MARK: - Variables - Initialized externally
    weak private var transformable: Transformable? = nil
    private let controlTypes: [TransformationType]
    
    // MARK: - Variables - Views
    private lazy var positionInput = SliderVector3View()
    private lazy var quaternionRotationInput = SliderVector4View()
    private lazy var eulerRotationInput = SliderVector3View()
    private lazy var scaleInput = SliderVector3View(minValue: 0.3)
    private lazy var opacityInput = SliderInputsView(axisLabels: ["   "], minValue: 0, maxValue: 1)
    private lazy var orientationInput = SliderVector4View()
    
    // MARK: - Public
    init(controlTypes: [TransformationType]) {
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
    
    func control(_ transformable: Transformable) {
        self.transformable = transformable
        
        for controlType in controlTypes {
            updateInput(for: controlType)
        }
    }
    
    // MARK: - Private
    private func setupInputView(for controlType: TransformationType) {
        addArrangedSubview(header(for: controlType))
        
        switch controlType {
        case .position:
            positionInput.setPanSpeed(0.04)
            positionInput.delegate = self
            addArrangedSubview(positionInput)
            
        case .quaternionRotation:
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
            
        case .opacity:
            opacityInput.viewDelegate = self
            opacityInput.setPanSpeed(0.01)
            addArrangedSubview(opacityInput)
            
        case .orientation:
            orientationInput.delegate = self
            orientationInput.setPanSpeed(0.007)
            addArrangedSubview(orientationInput)
        }
    }
    
    private func header(for type: TransformationType) -> UILabel {
        let label = UILabel()
        label.text = type.displayName
        label.font = UIFont.inputSliderHeader
        label.textColor = #colorLiteral(red: 0.9819386001, green: 0.9880417428, blue: 1, alpha: 1)
        return label
    }
    
    private func updateInput(for controlType: TransformationType) {
        
        guard let transformable = transformable, controlTypes.contains(controlType) else { return }
        
        switch controlType {
        case .position:
            positionInput.vector = transformable.position
        case .quaternionRotation:
            quaternionRotationInput.vector = transformable.rotation
        case .eulerRotation:
            eulerRotationInput.vector = transformable.eulerAngles
        case .scale:
            scaleInput.vector = transformable.scale
        case .opacity:
            opacityInput.setValue(Float(transformable.opacity), atIndex: 0)
        case .orientation:
            orientationInput.vector = transformable.orientation
        }
    }
}

extension TransformationPanel: SliderVector3ViewDelegate {
    func sliderVector3View(_ sliderVector3View: SliderVector3View, didChangeValues vector: SCNVector3) {
        if controlTypes.contains(.position) &&
            sliderVector3View == positionInput {
            transformable?.position = vector
            
        } else if controlTypes.contains(.eulerRotation) &&
            sliderVector3View == eulerRotationInput {
            transformable?.eulerAngles = vector
            
            updateInput(for: .quaternionRotation)
            updateInput(for: .orientation)

        } else if controlTypes.contains(.scale) &&
            sliderVector3View == scaleInput {
            transformable?.scale = vector
            
        } else {
            fatalError("Not implemented")
        }
    }
}

extension TransformationPanel: SliderVector4ViewDelegate {
    func sliderVector4View(_ sliderVector4View: SliderVector4View, didChangeValues vector: SCNVector4) {
        if controlTypes.contains(.quaternionRotation) &&
            sliderVector4View == quaternionRotationInput {
            transformable?.rotation = vector

            updateInput(for: .eulerRotation)
            updateInput(for: .orientation)

        } else if controlTypes.contains(.orientation) &&
            sliderVector4View == orientationInput {

            transformable?.orientation = vector
            
            updateInput(for: .quaternionRotation)
            updateInput(for: .eulerRotation)
            
        } else {
            fatalError("Not implemented")
        }
    }
}

extension TransformationPanel: SliderInputsViewDelegate {
    func sliderInputView(didChange value: Float, at index: Int) {
        transformable?.opacity = CGFloat(value)
    }
}
