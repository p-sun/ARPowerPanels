//
//  TransformationType.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-24.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import SceneKit

enum TransformationType {
    case name, boundingBox, opacity, scale, position, eulerRotation, quaternionRotation, orientation
    
    var displayName: String {
        switch self {
        case .name: return "Name"
        case .boundingBox: return "Bounding Box"
            
        case .position: return "Position"

        case .eulerRotation: return "Euler Rotation"
        case .quaternionRotation: return "Quaternion Rotation"
        case .orientation: return "Orientation"

        case .scale: return "Scale"

        case .opacity: return "Opacity"

        }
    }

    static var entityInfo: [TransformationType] {
        return [.name, .boundingBox]
    }
    
    static var transformations: [TransformationType] {
        return [.opacity, .position, .scale, .eulerRotation]
    }
    
    static var all: [TransformationType] {
        return [.name, .boundingBox, .opacity,
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
}

extension SCNNode: Transformable {
    var displayName: String {
        get {
            if let name = self.name {
                return name
            } else if parent == nil {
                return "Root Node"
            } else {
                return "Untitled"
            }
        }
        set {
            name = newValue
        }
    }
}