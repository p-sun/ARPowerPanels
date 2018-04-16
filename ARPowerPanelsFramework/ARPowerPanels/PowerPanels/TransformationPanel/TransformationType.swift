//
//  TransformationType.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-24.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import SceneKit

enum TransformationType {
    case name, boundingBox, showBoundingBox, showAxis, showLocalVector, opacity, scale, position, eulerRotation, quaternionRotation, orientation
    
    var displayName: String {
        switch self {
        case .name: return "Name"
        case .opacity: return "Opacity"
            
        case .boundingBox: return "Bounding Box"
        case .showBoundingBox: return "Show Bounding Box"
        case .showAxis: return "Show Axis"
        case .showLocalVector: return "Show Local Vector"
            
        case .position: return "Position"
            
        case .scale: return "Scale"
            
        case .eulerRotation: return "Euler Rotation"
        case .quaternionRotation: return "Quaternion Rotation"
        case .orientation: return "Orientation"
        }
    }

    static var entityInfo: [TransformationType] {
        return [.name, .opacity, .boundingBox,
                .showBoundingBox, .showAxis, .showLocalVector]
    }
    
    static var easyMove: [TransformationType] {
        return [.position, .scale, .eulerRotation]
    }

    static var advancedMove: [TransformationType] {
        return [.position, .scale, .eulerRotation, .quaternionRotation, .orientation]
    }
    
    static var all: [TransformationType] {
        return [.name, .opacity, .boundingBox,
                .showBoundingBox, .showAxis, .showLocalVector,
                .eulerRotation, .quaternionRotation, .orientation,
                .position,
                .scale]
    }
}

protocol Transformable: class {
    var displayName: String { get set }
    
    var boundingBox: (min: SCNVector3, max: SCNVector3) { get }
    var boundingSphere: (center: SCNVector3, radius: Float) { get }
    
    var opacity: CGFloat { get set }
    
    var position: SCNVector3 { get set }
    var scale: SCNVector3 { get set }
    
    // All affect the rotational aspect of the node’s transform property
    // Any change to one of these properties is reflected in the others.
    var rotation: SCNVector4 { get set }
    var eulerAngles: SCNVector3 { get set }
    var orientation: SCNQuaternion { get set }
    func addChildNode(_ child: SCNNode)
}

extension SCNNode: Transformable {
    var displayName: String {
        get {
            var icons = ""
            if light != nil {
                icons += "☀️"
            }
            if camera != nil {
                icons += "🎥"
            }
            if geometry != nil {
                icons += "📦"
            }
            if icons != "" {
                icons = "   " + icons
            }
            
            if let name = self.name {
                return name + icons
            } else if parent == nil {
                return "Root Node" + icons
            } else {
                return "Untitled" + icons
            }
        }
        set {
            name = newValue
        }
    }
}
