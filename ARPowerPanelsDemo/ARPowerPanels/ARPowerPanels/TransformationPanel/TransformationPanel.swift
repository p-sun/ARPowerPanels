//
//  TransformationPanel.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-22.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import SceneKit

protocol TransformationPanelDelegate: class {
    func transformationPanelDidChangeNodeName()
}

class TransformationPanel: UIStackView {
    
    // MARK: - Variables - Initialized externally
    weak var transformationDelegate: TransformationPanelDelegate?
    weak private var transformable: Transformable? = nil
    
    private let controlTypes: [TransformationType]
    
    // MARK: - Variables - Views
    private lazy var nameTextField = PowerPanelTextField()
    private lazy var boundingBoxLabel = header(for: .name)

    private lazy var positionInput = SliderVector3View()
    private lazy var quaternionRotationInput = SliderVector4View()
    private lazy var eulerRotationInput = SliderVector3View()
    private lazy var scaleInput = SliderVector3View(minValue: 0.2)
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
        
        if controlTypes.contains(.name) {
            nameTextField.text = transformable.displayName
        }
        
        updateInputs()
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateInputs), userInfo: nil, repeats: true)
    }
    
    @objc private func updateInputs() {
        for controlType in controlTypes {
            updateInput(for: controlType)
        }
    }
    
    // MARK: - Private
    private func setupInputView(for controlType: TransformationType) {
        addArrangedSubview(header(for: controlType))
        
        switch controlType {
        case .name:
            let stackView = UIStackView()
            let spacer = UIView()
            spacer.constrainWidth(40)
            stackView.addArrangedSubview(spacer)
            
            nameTextField.delegate = self
            stackView.addArrangedSubview(nameTextField)
            stackView.constrainHeight(29)
            addArrangedSubview(stackView)
            
        case .boundingBox:
            let stackView = UIStackView()
            let spacer = UIView()
            spacer.constrainWidth(40)
            stackView.addArrangedSubview(spacer)
            
            boundingBoxLabel.textColor = .uiControlColor
            stackView.addArrangedSubview(boundingBoxLabel)
            stackView.constrainHeight(29)
            addArrangedSubview(stackView)
            
        case .position:
            positionInput.constrainHeight(29)

            positionInput.setPanSpeed(0.0006)
            positionInput.delegate = self
            addArrangedSubview(positionInput)
            
        case .quaternionRotation:
            quaternionRotationInput.constrainHeight(29)

            quaternionRotationInput.delegate = self
            quaternionRotationInput.setPanSpeed(0.007)
            addArrangedSubview(quaternionRotationInput)
            
        case .eulerRotation:
            eulerRotationInput.constrainHeight(29)

            eulerRotationInput.delegate = self
            eulerRotationInput.setPanSpeed(1)
            addArrangedSubview(eulerRotationInput)
            
        case .scale:
            scaleInput.constrainHeight(29)

            scaleInput.delegate = self
            scaleInput.setPanSpeed(0.002)
            addArrangedSubview(scaleInput)
            
        case .opacity:
            opacityInput.constrainHeight(29)

            opacityInput.viewDelegate = self
            opacityInput.setPanSpeed(0.01)
            addArrangedSubview(opacityInput)
            
        case .orientation:
            orientationInput.constrainHeight(29)

            orientationInput.delegate = self
            orientationInput.setPanSpeed(0.005)
            addArrangedSubview(orientationInput)
        }
    }
    
    private func header(for type: TransformationType) -> UILabel {
        let label = UILabel()
        label.text = type.displayName
        label.font = UIFont.inputSliderHeader
        label.constrainHeight(34, priority: .init(998))
        label.textColor = #colorLiteral(red: 0.9819386001, green: 0.9880417428, blue: 1, alpha: 1)
        return label
    }
    
    private func updateInput(for controlType: TransformationType) {
        
        guard let transformable = transformable, controlTypes.contains(controlType) else { return }
        
        switch controlType {
        case .name:
            break
        case .boundingBox:
            boundingBoxLabel.text = boundingBoxText(for: transformable)
        case .position:
            positionInput.vector = transformable.position
        case .quaternionRotation:
            quaternionRotationInput.vector = transformable.rotation
        case .eulerRotation:
            let radiansVector = transformable.eulerAngles
            eulerRotationInput.vector = radiansVector.radiansToDegrees
        case .scale:
            scaleInput.vector = transformable.scale
        case .opacity:
            opacityInput.setValue(Float(transformable.opacity), atIndex: 0)
        case .orientation:
            orientationInput.vector = transformable.orientation
        }
    }

    private func boundingBoxText(for transformable: Transformable) -> String {
        let box = transformable.boundingBox
        let diffBox = box.max - box.min
        let diffBoxX = diffBox.x.decimalString(2)
        let diffBoxY = diffBox.y.decimalString(2)
        let diffBoxZ = diffBox.z.decimalString(2)
        return "Width: \(diffBoxX), Depth: \(diffBoxY), Height: \(diffBoxZ)"
    }
}

extension TransformationPanel: PowerPanelTextFieldDelegate {
    func powerPanelTextField(didChangeText text: String?) {
        transformable?.displayName = text ?? ""
        transformationDelegate?.transformationPanelDidChangeNodeName()
    }
}

extension TransformationPanel: SliderVector3ViewDelegate {
    func sliderVector3View(_ sliderVector3View: SliderVector3View, didChangeValues vector: SCNVector3) {
        if controlTypes.contains(.position) &&
            sliderVector3View == positionInput {
            transformable?.position = vector
            
        } else if controlTypes.contains(.eulerRotation) &&
            sliderVector3View == eulerRotationInput {
            transformable?.eulerAngles = vector.degreesToRadians
            
//            updateInput(for: .quaternionRotation)
//            updateInput(for: .orientation)

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
        // There are two Vector 4 inputs -- quaternion and orientation
        // If the values in either of these are updated by the user, update the others
        if controlTypes.contains(.quaternionRotation) &&
            sliderVector4View == quaternionRotationInput {
            transformable?.rotation = vector

//            updateInput(for: .eulerRotation)
//            updateInput(for: .orientation)

        } else if controlTypes.contains(.orientation) &&
            sliderVector4View == orientationInput {

            transformable?.orientation = vector

//            updateInput(for: .quaternionRotation)
//            updateInput(for: .eulerRotation)

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

private extension SCNVector3 {
    var degreesToRadians: SCNVector3 {
        return SCNVector3Make(x.degreesToRadians,
                              y.degreesToRadians,
                              z.degreesToRadians)
    }
    var radiansToDegrees: SCNVector3 {
        return SCNVector3Make(x.radiansToDegrees,
                              y.radiansToDegrees,
                              z.radiansToDegrees)
    }
}

private extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
