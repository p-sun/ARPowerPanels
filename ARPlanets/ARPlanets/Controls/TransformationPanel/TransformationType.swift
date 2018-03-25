//
//  TransformationType.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-24.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import SceneKit

enum TransformationType {
    case opacity, scale, position, eulerRotation, quaternionRotation, orientation
    
    var displayName: String {
        switch self {
        case .position: return "Position"
        case .eulerRotation: return "Euler Rotation"
        case .quaternionRotation: return "Quaternion Rotation"
        case .scale: return "Scale"
        case .opacity: return "Opacity"
        case .orientation: return "Orientation"
        }
    }
    
    static var minimum: [TransformationType] {
        return [.opacity, .position, .scale, .eulerRotation]
    }
    
    static var all: [TransformationType] {
        return [.opacity, .position, .scale, .eulerRotation, .quaternionRotation, .orientation]
    }
}

protocol Transformable: class {
    var opacity: CGFloat { get set }
    
    var position: SCNVector3 { get set }
    var scale: SCNVector3 { get set }
    
    // All affect the rotational aspect of the node’s transform property
    // Any change to one of these properties is reflected in the others.
    var rotation: SCNVector4 { get set }
    var eulerAngles: SCNVector3 { get set }
    var orientation: SCNQuaternion { get set }
}

extension SCNNode: Transformable { }
