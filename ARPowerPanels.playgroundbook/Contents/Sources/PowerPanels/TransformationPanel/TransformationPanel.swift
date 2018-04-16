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
    func transformationPanelDidEditNode()
}

class TransformationPanel: UIStackView {
    
    // MARK: - Variables - Initialized externally
    weak var transformationDelegate: TransformationPanelDelegate?
    weak private var transformable: Transformable? = nil
    
    private let controlTypes: [TransformationType]
    
    // MARK: - Variables - Views
    private lazy var nameTextField = PowerPanelTextField()
    private lazy var opacityInput = SliderInputsView(axisLabels: ["   "], minValue: 0, maxValue: 1)
    private lazy var boundingBoxLabel = header(for: .name)
    
    private lazy var showBoundingBoxSwitch = PowerPanelCheckmarkInput(text: TransformationType.showBoundingBox.displayName)
    private lazy var showAxisSwitch = PowerPanelCheckmarkInput(text: TransformationType.showAxis.displayName)
    private lazy var showLocalVectorSwitch = PowerPanelCheckmarkInput(text: TransformationType.showLocalVector.displayName)
    
    private lazy var positionInput = SliderVector3View()
    private lazy var quaternionRotationInput = SliderVector4View()
    private lazy var eulerRotationInput = SliderVector3View()
    private lazy var scaleInput = SliderVector3View(minValue: 0.2)
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
        
        if controlTypes.contains(.showBoundingBox), let node = transformable as? SCNNode {
            let boxNode = node.directChildNode(withName: NodeNames.boundingBox.rawValue)
            let hasBoundingBox = boxNode != nil
            showBoundingBoxSwitch.isChecked = hasBoundingBox
        }
        
        if controlTypes.contains(.showAxis),  let node = transformable as? SCNNode {
            let axisNode = node.directChildNode(withName: NodeNames.axis.rawValue)
            let hasAxis = axisNode != nil
            showAxisSwitch.isChecked = hasAxis
        }
        
        if controlTypes.contains(.showLocalVector), let node = transformable as? SCNNode {
            let localVectorNode = node.directChildNode(withName: NodeNames.localVector.rawValue)
            let hasVector = localVectorNode != nil
            showLocalVectorSwitch.isChecked = hasVector
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
        if controlType != .showBoundingBox &&
            controlType != .showAxis &&
            controlType != .showLocalVector {
            addArrangedSubview(header(for: controlType))
        }
        
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
        
        case .showBoundingBox:
            showBoundingBoxSwitch.delegate = self
            showBoundingBoxSwitch.constrainHeight(37)
            addArrangedSubview(showBoundingBoxSwitch)
        
        case .showAxis:
            showAxisSwitch.delegate = self
            showAxisSwitch.constrainHeight(37) // 29 + 8 for insets
            addArrangedSubview(showAxisSwitch)
        
        case .showLocalVector:
            showLocalVectorSwitch.delegate = self
            showLocalVectorSwitch.constrainHeight(37)
            addArrangedSubview(showLocalVectorSwitch)
            
        case .position:
            positionInput.constrainHeight(29)

            positionInput.setPanSpeed(0.0005)
            positionInput.delegate = self
            addArrangedSubview(positionInput)
            
        case .quaternionRotation:
            quaternionRotationInput.constrainHeight(29)

            quaternionRotationInput.delegate = self
            quaternionRotationInput.setPanSpeed(0.8)
            addArrangedSubview(quaternionRotationInput)
            
        case .eulerRotation:
            eulerRotationInput.constrainHeight(29)

            eulerRotationInput.delegate = self
            eulerRotationInput.setPanSpeed(0.8)
            addArrangedSubview(eulerRotationInput)
            
        case .scale:
            scaleInput.constrainHeight(29)

            scaleInput.delegate = self
            scaleInput.setPanSpeed(0.003)
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
        case .name, .showBoundingBox, .showAxis, .showLocalVector:
            // UI Controls that only need to be updated when the selectedNode is changed
            // are updated in control(transformable), not here
            break
        
        case .boundingBox:
            boundingBoxLabel.text = boundingBoxText(for: transformable)
        case .position:
            positionInput.vector = transformable.position
        case .quaternionRotation:
            let rotation = transformable.rotation
            let displayRotation = SCNVector4Make(rotation.x, rotation.y, rotation.z, rotation.w.radiansToDegrees)
            quaternionRotationInput.vector = displayRotation
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
        transformationDelegate?.transformationPanelDidEditNode()
    }
}

// MARK: - Checkmark Input
extension TransformationPanel: PowerPanelCheckmarkInputDelegate {
    func powerPanelCheckmarkInput(_ checkMarkInput: PowerPanelCheckmarkInput, isCheckedDidChange isChecked: Bool) {
        guard let transformable = transformable else {
            return
        }
        
        if checkMarkInput == showBoundingBoxSwitch {
            updateBoundingBoxNode(transformable: transformable, isChecked: isChecked)
        } else if checkMarkInput == showAxisSwitch {
            updateAxisNode(transformable: transformable, isChecked: isChecked)
        } else if checkMarkInput == showLocalVectorSwitch {
            updateLocalVectorNode(transformable: transformable, isChecked: isChecked)
        }
    }
}

// MARK: - Show Bounding Box // TODO refactor
extension TransformationPanel {
    static func addBoundingBox(for transformable: Transformable) {
        func translucentBoundingBox(for transformable: Transformable) -> SCNNode {
            let boundingBoxName = NodeNames.boundingBox.rawValue

            let boundingBox = transformable.boundingBox
            let diffBox = boundingBox.max - boundingBox.min
            let translucentBox = SCNBox(width: CGFloat(diffBox.x), height: CGFloat(diffBox.y), length: CGFloat(diffBox.z), chamferRadius: 0)
            let tranlucentWhite = UIColor.white.withAlphaComponent(0.3)
            translucentBox.materials = [SCNMaterial.material(withDiffuse: tranlucentWhite, respondsToLighting: false)]
            let boxNode = SCNNode(geometry: translucentBox)
            boxNode.name = boundingBoxName
            
            let middlePosition = (boundingBox.min + boundingBox.max) / 2
            boxNode.position = middlePosition
            return boxNode
        }
        
        let boundingBoxNode = translucentBoundingBox(for: transformable)
        transformable.addChildNode(boundingBoxNode)
    }
    
    private func updateBoundingBoxNode(transformable: Transformable, isChecked: Bool) {
        if isChecked {
            TransformationPanel.addBoundingBox(for: transformable)
            transformationDelegate?.transformationPanelDidEditNode() // Update the SceneGraph
        } else if let selectedNode = transformable as? SCNNode,
            let boundingBoxNode = selectedNode.directChildNode(withName: NodeNames.boundingBox.rawValue) {
            boundingBoxNode.removeFromParentNode()
            transformationDelegate?.transformationPanelDidEditNode()
        }
    }
}

// MARK: - Show Axis
extension TransformationPanel {
    private func addAxisNode(for transformable: Transformable) {
        guard let parentNode = transformable as? SCNNode else { return }

        let axisNode = NodeCreator.createAxesNode(quiverLength: 0.15, quiverThickness: 1.0)
        axisNode.name = NodeNames.axis.rawValue
        axisNode.transform = parentNode.pivot
        SceneGraphManager.shared.addNode(axisNode, to: parentNode)
    }
    
    private func updateAxisNode(transformable: Transformable, isChecked: Bool) {
        if isChecked {
            addAxisNode(for: transformable)
            transformationDelegate?.transformationPanelDidEditNode()
        } else if let selectedNode = transformable as? SCNNode,
            let axisNode = selectedNode.directChildNode(withName: NodeNames.axis.rawValue) {
            SceneGraphManager.shared.removeNode(axisNode)
            transformationDelegate?.transformationPanelDidEditNode()
        }
    }
}

// MARK: - Show Local Vector
extension TransformationPanel {
    private func addLocalVectorNode(for transformable: Transformable) {
        guard let parentNode = transformable as? SCNNode, let grandparentNode = parentNode.parent else { return }
        
        let localVectorNode = NodeCreator.createArrowNode(fromNode: grandparentNode, toNode: parentNode)
        localVectorNode.name = NodeNames.localVector.rawValue
        SceneGraphManager.shared.addNode(localVectorNode, to: parentNode)
    }
    
    private func updateLocalVectorNode(transformable: Transformable, isChecked: Bool) {
        if isChecked {
            addLocalVectorNode(for: transformable)
            transformationDelegate?.transformationPanelDidEditNode()
        } else if let selectedNode = transformable as? SCNNode,
            let localVectorNode = selectedNode.directChildNode(withName: NodeNames.localVector.rawValue) {
            SceneGraphManager.shared.removeNode(localVectorNode)
            transformationDelegate?.transformationPanelDidEditNode()
        }
    }
}

// MARK: - Position, Euler Rotation, Scale
extension TransformationPanel: SliderVector3ViewDelegate {
    func sliderVector3View(_ sliderVector3View: SliderVector3View, didChangeValues vector: SCNVector3) {
        if controlTypes.contains(.position) &&
            sliderVector3View == positionInput {
            transformable?.position = vector
            
        } else if controlTypes.contains(.eulerRotation) &&
            sliderVector3View == eulerRotationInput {
            transformable?.eulerAngles = vector.degreesToRadians

        } else if controlTypes.contains(.scale) &&
            sliderVector3View == scaleInput {
            transformable?.scale = vector
            
        } else {
            fatalError("Not implemented")
        }
    }
}

// MARK: - Quaternion Rotation
extension TransformationPanel: SliderVector4ViewDelegate {
    func sliderVector4View(_ sliderVector4View: SliderVector4View, didChangeValues vector: SCNVector4) {

        if controlTypes.contains(.quaternionRotation) &&
            sliderVector4View == quaternionRotationInput {
            
            let newVector = SCNVector4Make(vector.x, vector.y, vector.z, vector.w.degreesToRadians)
            transformable?.rotation = newVector

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

// MARK: - Opacity
extension TransformationPanel: SliderInputsViewDelegate {
    func sliderInputView(didChange value: Float, at index: Int) {
        transformable?.opacity = CGFloat(value)
    }
}

// MARK: - Helpers
extension SCNNode { // TODO move this to an
    func directChildNode(withName name: String) -> SCNNode? {
        for child in childNodes {
            if child.name?.contains(name) == true {
                return child
            }
        }
        return nil
    }
}

public extension SCNVector3 {
    public var degreesToRadians: SCNVector3 {
        return SCNVector3Make(x.degreesToRadians,
                              y.degreesToRadians,
                              z.degreesToRadians)
    }
    public var radiansToDegrees: SCNVector3 {
        return SCNVector3Make(x.radiansToDegrees,
                              y.radiansToDegrees,
                              z.radiansToDegrees)
    }
}

public extension FloatingPoint {
    public var degreesToRadians: Self { return self * .pi / 180 }
    public var radiansToDegrees: Self { return self * 180 / .pi }
}
