//
//  SCNScene+Glow.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-30.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import SceneKit
import ARKit

extension SCNNode {
    func setGlow(_ shouldGlow: Bool) {
        enumerateHierarchy({ (node, _) in
            node.categoryBitMask = shouldGlow ? 2 : 1
        })
    }
}

extension SCNView { // SCNTechniqueSupport
    func setupGlowTechnique() {
        let bundle = Bundle(for: ModelCollectionView.self)
        if let path = bundle.path(forResource: "NodeTechnique", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path)  {
                let dict2 = dict as! [String : AnyObject]
                let technique = SCNTechnique(dictionary:dict2)
                self.technique = technique
            }
        }
    }
}
