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
    case wolf, fox, greenBall, lowPolyTree, blueBox
    
    static func assetTypesForMenu() -> [Model] {
        return [.wolf, .fox, .greenBall, .lowPolyTree, .blueBox]
    }
    
    func createNode() -> SCNNode {
        switch self {
        case .fox:
            let scene = SCNScene(named: "art.scnassets/fox/max.scn")!
            let foxNode = scene.rootNode.childNode(withName: "Max_rootNode", recursively: true)!
            foxNode.scale = SCNVector3Make(10, 10, 10)
            let parentNode = SCNNode()
            parentNode.name = "FOX PARENT"
            parentNode.addChildNode(foxNode)
            return parentNode
        case .wolf:
            return nodeFromResource(assetName: "wolf/wolf", extensionName: "dae")
        case .blueBox:
            return NodeCreator.blueBox()
        case .greenBall:
            return nodeFromResource(assetName: "greenBall", extensionName: "dae")
        case .lowPolyTree:
            return nodeFromResource(assetName: "lowPolyTree", extensionName: "dae")
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
        case .blueBox:
            return #imageLiteral(resourceName: "menuBlueBox")
        case .greenBall:
            return #imageLiteral(resourceName: "menuGreenBall")
        case .lowPolyTree:
            return #imageLiteral(resourceName: "menuLowPolyTree")
        case .fox:
            return #imageLiteral(resourceName: "menuLowPolyTree") // TODO needs image
        }
    }
}

extension SCNNode {
//    func getChildNodeToGlow(type)
}
