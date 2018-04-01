//
//  ModelAssetType.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import SceneKit

protocol NodeMaker {
    static var allTypes: [NodeMaker] { get }
    var menuImage: UIImage { get }
    func createNode() -> SCNNode
}

enum Shapes: NodeMaker {
    
    case sphere, plane, box, pyramid, cylinder, cone, torus, tube, capsule
    
    static var allTypes: [NodeMaker] {
        return [Shapes.sphere, Shapes.plane, Shapes.box, Shapes.pyramid, Shapes.cylinder, Shapes.cone, Shapes.torus, Shapes.tube, Shapes.capsule]
    }
    
    var menuImage: UIImage {
        switch self {
        case .sphere:
            return #imageLiteral(resourceName: "sphere")
        case .plane:
            return #imageLiteral(resourceName: "plane")
        case .box:
            return #imageLiteral(resourceName: "box")
        case .pyramid:
            return #imageLiteral(resourceName: "pyramid")
        case .cylinder:
            return #imageLiteral(resourceName: "cylinder")
        case .cone:
            return #imageLiteral(resourceName: "cone")
        case .torus:
            return #imageLiteral(resourceName: "torus")
        case .tube:
            return #imageLiteral(resourceName: "tube")
        case .capsule:
            return #imageLiteral(resourceName: "capsule")
        }
    }
    
    func createNode() -> SCNNode {
        let node = SCNNode()
        node.geometry = geometry(for: self)
        return node
    }
    
    private func geometry(for type: Shapes) -> SCNGeometry {
        switch self {
        case .sphere:
            return SCNSphere(radius: 1.0)
        case .plane:
            return SCNPlane(width: 1.0, height: 1.5)
        case .box:
            return SCNBox(width: 1.0, height: 1.5, length: 2.0, chamferRadius: 0.0)
        case .pyramid:
            return SCNPyramid(width: 2.0, height: 1.5, length: 1.0)
        case .cylinder:
            return SCNCylinder(radius: 1.0, height: 1.5)
        case .cone:
            return SCNCone(topRadius: 0.5, bottomRadius: 1.0, height: 1.5)
        case .torus:
            return SCNTorus(ringRadius: 1.0, pipeRadius: 0.2)
        case .tube:
            return SCNTube(innerRadius: 0.5, outerRadius: 1.0, height: 1.5)
        case .capsule:
            return SCNCapsule(capRadius: 0.5, height: 2.0)
        }
    }
}

enum Model: NodeMaker {
    case axis, wolf, fox, lowPolyTree, camera
    
    static var allTypes: [NodeMaker] {
        return [Model.axis, Model.wolf, Model.fox, Model.lowPolyTree]
    }
    
    func createNode() -> SCNNode {
        switch self {
        case .axis:
             return NodeCreator.createAxesNode(quiverLength: 0.5, quiverThickness: 0.2)
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
    
    var menuImage: UIImage {
        switch self {
        case .axis:
            return #imageLiteral(resourceName: "menuAxis")
        case .wolf:
            return #imageLiteral(resourceName: "menuWolf") // TODO? Remove this? This is a really big file compared to the fox
        case .lowPolyTree:
            return #imageLiteral(resourceName: "menuLowPolyTree")
        case .fox:
            return #imageLiteral(resourceName: "fox_squareLQ")
        case .camera:
           return #imageLiteral(resourceName: "menuLowPolyTree")
        }
    }
}
