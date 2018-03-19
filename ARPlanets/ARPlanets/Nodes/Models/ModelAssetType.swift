//
//  ModelAssetType.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-18.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit
import SceneKit

enum Model: String {
    case wolf, fox, greenBall, lowPolyTree, blueBox
    
    static func assetTypesForMenu() -> [Model] {
        return [.wolf, .fox, .greenBall, .lowPolyTree, .blueBox]
    }
    
    func createNode() -> SCNNode {
        switch self {
        case .fox:
            let scene = SCNScene(named: "art.scnassets/fox/max.scn")!
            let foxNode = scene.rootNode.childNode(withName: "Max_rootNode", recursively: true)!
            foxNode.scale = SCNVector3Make(0.3, 0.3, 0.3)
            return foxNode
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
            return #imageLiteral(resourceName: "menuWolf")
        case .blueBox:
            return #imageLiteral(resourceName: "menuBlueBox")
        case .greenBall:
            return #imageLiteral(resourceName: "menuGreenBall")
        case .lowPolyTree:
            return #imageLiteral(resourceName: "menuLowPolyTree")
        case .fox:
            return #imageLiteral(resourceName: "menuLowPolyTree") // TODO
        }
    }
}
