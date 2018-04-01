//
//  ModelAssetType.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import SceneKit

enum Model {
    case wolf, fox, lowPolyTree, camera
    
    static func assetTypesForMenu() -> [Model] {
        return [.wolf, .fox, .lowPolyTree]
    }
    
    func createNode() -> SCNNode {
        switch self {
        case .fox:
            let parentNode = SCNNode()
            parentNode.name = "Fox 🦊"
            
            let scene = SCNScene(named: "art.scnassets/fox/max.scn")!
            let foxNode = scene.rootNode.childNode(withName: "Max_rootNode", recursively: true)!
            foxNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
            parentNode.addChildNode(foxNode)
            
            return parentNode
        case .wolf:
            return nodeFromResource(assetName: "wolf/wolf", extensionName: "dae")
        case .lowPolyTree:
            return nodeFromResource(assetName: "lowPolyTree", extensionName: "dae")
        case .camera:
            let rootCamera = nodeFromResource(assetName: "camera", extensionName: "scn")
            return rootCamera.childNode(withName: "Camera Shape", recursively: true)!
        }
    }
    
    func nodeFromResource(assetName: String, extensionName: String) -> SCNNode {
        let url = Bundle.main.url(forResource: "art.scnassets/\(assetName)", withExtension: extensionName)!
        let node = SCNReferenceNode(url: url)!
        
        node.name = assetName
        node.load()
        return node
    }
    
    func menuImage() -> UIImage {
        switch self {
        case .wolf:
            return #imageLiteral(resourceName: "menuWolf") // TODO? Remove this? This is a really big file compared to the fox
        case .lowPolyTree:
            return #imageLiteral(resourceName: "menuLowPolyTree")
        case .fox:
            return #imageLiteral(resourceName: "menuLowPolyTree") // TODO needs image
        case .camera:
           return #imageLiteral(resourceName: "menuLowPolyTree")
        }
    }
}
