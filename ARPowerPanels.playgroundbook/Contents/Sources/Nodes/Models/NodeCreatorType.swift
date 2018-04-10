//
//  NodeCreatorType.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import SceneKit

protocol NodeCreatorType {
    static var allTypes: [NodeCreatorType] { get }
    var menuImage: UIImage? { get }
    func createNode() -> SCNNode?
}

public enum Shapes: NodeCreatorType {

    case sphere, plane, box, pyramid, cylinder, cone, torus, tube, capsule
    
    static var allTypes: [NodeCreatorType] {
        return [Shapes.sphere, Shapes.plane, Shapes.box, Shapes.pyramid, Shapes.cylinder, Shapes.cone, Shapes.torus, Shapes.tube, Shapes.capsule]
    }
    
    var menuImage: UIImage? {
        if isPlaygroundBook {
            // THIS IS FOR THE PLAYGROUND
            // Images have go in the 'Contents/PrivateResources` folder,
            // as opposed to in the Assets.xcassets folder for Xcode.
            // They also must be referred to by with their image extension
            switch self {
            case .sphere:
                return #imageLiteral(resourceName: "shapeSphere.png")
            case .plane:
                return #imageLiteral(resourceName: "shapePlane.png")
            case .box:
                return #imageLiteral(resourceName: "shapeBox.png")
            case .pyramid:
                return #imageLiteral(resourceName: "shapePyramid.png")
            case .cylinder:
                return #imageLiteral(resourceName: "shapeCylinder.png")
            case .cone:
                return #imageLiteral(resourceName: "shapeCone.png")
            case .torus:
                return #imageLiteral(resourceName: "shapeTorus.png")
            case .tube:
                return #imageLiteral(resourceName: "shapeTube.png")
            case .capsule:
                return #imageLiteral(resourceName: "shapeCapsule.png")
            }
            
        } else {
            // THIS IS FOR XCODE
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
    }
    
    public func createNode() -> SCNNode? {
        let basicGeometry = geometry(for: self)
        basicGeometry.firstMaterial?.diffuse.contents = UIColor.randomColor()
        
        let childNode = SCNNode()
        childNode.geometry = basicGeometry
        childNode.scale = SCNVector3Make(0.03, 0.03, 0.03)
        
        let parentNode = SCNNode()
        parentNode.name = "\(self)"
        parentNode.addChildNode(childNode)
        return parentNode
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

public enum Model: NodeCreatorType {
    case wolf, fox, lowPolyTree, camera, custom
    
    static var allTypes: [NodeCreatorType] {
        return [Model.wolf, Model.fox, Model.lowPolyTree] // TODO remove the Axis assets
    }
    
    public func createNode() -> SCNNode? {
        switch self {
        case .fox:
            let parentNode = SCNNode()
            parentNode.name = "Fox 🦊"
            
            let bundle = Bundle(for: ModelCollectionView.self)
            if let url = bundle.url(forResource: "art.scnassets/fox/max", withExtension: "scn"),
                let scene = try? SCNScene(url: url),
                let foxNode = scene.rootNode.childNode(withName: "Max_rootNode", recursively: true)?.clone() {
                foxNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
                parentNode.addChildNode(foxNode)
                return parentNode
            }
            NSLog("PAIGE LOG: COULD NOT LOAD FOX MODEL")
            return nil
        case .wolf:
            return nodeFromResource(assetName: "wolf/wolf", extensionName: "dae")?.clone()
        case .lowPolyTree:
            return nodeFromResource(assetName: "lowPolyTree", extensionName: "dae")?.clone()
        case .camera:
            let rootCamera = nodeFromResource(assetName: "camera", extensionName: "scn")
            return rootCamera?.childNode(withName: "Camera Shape", recursively: true)
        case .custom:
            return SCNNode()
        }
    }
    
    func nodeFromResource(assetName: String, extensionName: String) -> SCNNode? {
        let bundle = Bundle(for: ModelCollectionView.self)
        
        if let url = bundle.url(forResource: "art.scnassets/\(assetName)", withExtension: extensionName) {
            NSLog("PAIGE LOG url \(url)")
            
            if let node = SCNReferenceNode(url: url) {
                node.name = assetName
                node.load()
                return node
                
            }
        } else {
            NSLog("PAIGE LOG: COULD NOT LOAD FROM RESOURCE")
        }
        return nil
    }
    
    var menuImage: UIImage? {
        if isPlaygroundBook {
            switch self {
            case .wolf:
                return #imageLiteral(resourceName: "menuWolf.png")
            case .lowPolyTree:
                return #imageLiteral(resourceName: "menuLowPolyTree.png")
            case .fox:
                return #imageLiteral(resourceName: "fox_squareLQ.jpeg")
            case .camera:
                return #imageLiteral(resourceName: "menuLowPolyTree.png")
            case .custom:
                return #imageLiteral(resourceName: "menuLowPolyTree.png")
            }
        } else {
            switch self {
            case .wolf:
                return #imageLiteral(resourceName: "menuWolf")
            case .lowPolyTree:
                return #imageLiteral(resourceName: "menuLowPolyTree")
            case .fox:
                return #imageLiteral(resourceName: "fox_squareLQ")
            case .camera:
                return #imageLiteral(resourceName: "menuLowPolyTree")
            case .custom:
                return #imageLiteral(resourceName: "menuLowPolyTree")
            }
        }
    }
}
