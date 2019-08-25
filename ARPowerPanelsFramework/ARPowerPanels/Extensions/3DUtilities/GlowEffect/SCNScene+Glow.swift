//
//  SCNScene+Glow.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-30.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import SceneKit

struct GlowNodes {
    static let glowMaterial: SCNMaterial = {
        let mat = SCNMaterial()
        mat.emission.contents = UIColor.red.withAlphaComponent(0.3)
        mat.name = "Glow Material"
        return mat
    }()
}

extension SCNNode {
    func setGlow(_ shouldGlow: Bool) {
        func setGlowMaterial(on node: SCNNode) -> Bool {
            if shouldGlow {
                if let allMaterials = node.geometry?.materials {
                    if !allMaterials.contains(GlowNodes.glowMaterial) {
                        node.geometry?.materials = [GlowNodes.glowMaterial] + allMaterials
                        return true
                    }
                }
            } else {
                if let glowindex = node.geometry?.materials.index(of: GlowNodes.glowMaterial) {
                    node.geometry?.materials.remove(at: glowindex)
                    return true
                }
            }
            return false
        }

        if name == TransformationType.boundingBox.displayName {
            return
        }
        
        if !setGlowMaterial(on: self) {
            for child in childNodes {
                child.setGlow(shouldGlow)
            }
        }
        
        // For metal shader
//        categoryBitMask = shouldGlow ? 2 : 1
//        enumerateHierarchy({ (node, _) in
//            node.categoryBitMask = shouldGlow ? 2 : 1
//        })
    }
}

// Initialize Metal Shader
//extension SCNView {
//    public func setupGlowTechnique() {
//        let bundle = Bundle(for: ModelCollectionView.self)
//        if let path = bundle.path(forResource: "NodeTechnique", ofType: "plist") {
//            if let dict = NSDictionary(contentsOfFile: path)  {
//                let dict2 = dict as! [String : AnyObject]
//                let technique = SCNTechnique(dictionary:dict2)
//                self.technique = technique
//            }
//        }
//    }
//}
