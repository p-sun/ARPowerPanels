//
//  HierachyPanel.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-28.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import SceneKit

class HierachyPanel {
    
    init(scene: SCNScene) {
        iterateThough(node: scene.rootNode, level: 0)
    }
 
    func iterateThough(node: SCNNode, level: Int) {
        var spaces = ""
        for _ in 0 ... level {
            spaces += "-"
        }
        let name: String
        if level == 0 {
            name = "Root Node"
        } else {
            name = node.name ?? "untitled"
        }
        
        print("\(spaces) node \(name)")
        
        for child in node.childNodes {
            iterateThough(node: child, level: level + 1)
        }
    }
    
}
