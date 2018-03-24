//
//  NodeControlType.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-24.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import Foundation

enum NodeControlType {
    case position, eulerRotation, quaterionRotation, scale
    
    var displayName: String {
        switch self {
        case .position: return "Postion"
        case .eulerRotation: return "Euler Rotation"
        case .quaterionRotation: return "Quaterion Rotation"
        case .scale: return "Scale"
        }
    }
}
