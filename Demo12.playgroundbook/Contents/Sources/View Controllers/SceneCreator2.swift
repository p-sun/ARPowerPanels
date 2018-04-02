//
//  SceneCreator.swift
//  ARPowerPanelsDemo
//
//  Created by TSD040 on 2018-04-01.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import Foundation
import SceneKit

public struct NodeMetaData {
    let displayInHierachy: Bool
    
    init(displayInHierachy: Bool) {
        self.displayInHierachy = displayInHierachy
    }
}


public class SceneCreator {
    
    public static let shared = SceneCreator()
    
    private var nodeMetaDatas = [SCNNode: NodeMetaData]()
    
    public func createFoxPlaneScene() -> SCNScene {
        let scene = SCNScene()
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.name = "Light node"
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.name = "Ambient Light Node"
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        if let foxNode = Model.fox.createNode() {
            addNode(foxNode, to: scene.rootNode)
        } else {
            NSLog("PAIGE LOG could not get model for fox node")
        }
        
        // Animate the 3d object
        // foxNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        //        let anotherFoxModel = Model.fox.createNode()
        //        scene.rootNode.addChildNode(anotherFoxModel)
        //        anotherFoxModel.position = SCNVector3Make(1, 1, 1)
        //        nodeMetaDatas[anotherFoxModel] = NodeMetaData(modelType: .fox)
        
        if let newAxisNode = Model.axis.createNode() {
            addNode(newAxisNode, to: scene.rootNode)
        } else {
            NSLog("PAIGE LOG could not get model for axis node")
        }
        
        scene.rootNode.updateFocusIfNeeded()
        
        return scene
    }
    
    func addNode(_ node: SCNNode, to parentNode: SCNNode) {
        parentNode.addChildNode(node)
        
        nodeMetaDatas[node] = NodeMetaData(displayInHierachy: true)
        node.enumerateChildNodes { (child, _) in
            nodeMetaDatas[child] = NodeMetaData(displayInHierachy: false)
        }
        
        nodeMetaDatas[parentNode] = NodeMetaData(displayInHierachy: true)
    }
    
    func removeNode(_ node: SCNNode?) {
        guard let node = node else { return }
        node.removeFromParentNode()
        node.enumerateHierarchy { (node, _) in
            nodeMetaDatas[node] = nil
        }
    }
    
    func displayInHierachy(node: SCNNode) -> Bool {
        let metadata = nodeMetaDatas[node]
        return metadata?.displayInHierachy ?? true
    }
}
