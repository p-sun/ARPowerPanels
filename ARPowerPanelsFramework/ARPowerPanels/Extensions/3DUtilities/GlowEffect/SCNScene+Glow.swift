//
//  SCNScene+Glow.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-30.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import SceneKit

let glowMaterial: SCNMaterial = {
    let mat = SCNMaterial()
    mat.emission.contents = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    mat.name = "Glow Material"
    return mat
}()

extension SCNNode {
    func setGlow(_ shouldGlow: Bool) {

        func setGlow(on node: SCNNode) {
            if shouldGlow {
                if let allMaterials = node.geometry?.materials {
                    if !allMaterials.contains(glowMaterial) {
                        node.geometry?.materials = [glowMaterial] + allMaterials
                    }
                }
            } else {
                if let glowindex = node.geometry?.materials.index(of: glowMaterial) {
                    node.geometry?.materials.remove(at: glowindex)
                }
            }
        }
        
        setGlow(on: self)
        enumerateHierarchy({ (node, _) in
           setGlow(on: node)
        })
        
        // For metal shader if needed
//        categoryBitMask = shouldGlow ? 2 : 1
//        enumerateHierarchy({ (node, _) in
//            node.categoryBitMask = shouldGlow ? 2 : 1
//        })
    }
}

extension SCNView {
    public func setupGlowTechnique() {
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
