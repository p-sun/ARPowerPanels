//
//  NodeControlType.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-24.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import Foundation

enum NodeControlType {
    case position, eulerRotation, quaterionRotation, scale
    
    var displayName: String {
        switch self {
        case .position: return "Postion"
        case .eulerRotation: return "Euler rotation"
        case .quaterionRotation: return "Quaterion rotation"
        case .scale: return "Scale"
        }
    }
}
