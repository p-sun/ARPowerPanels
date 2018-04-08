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

        //#-hidden-code
//        import UIKit
//        import SceneKit
//        import ARKit
//        import PlaygroundSupport
        //#-end-hidden-code
        
        //#-editable-code Tap to enter code
        
        //: ## Create a scene
        let scene = SCNScene()
        
        //: ## Add a light to the scene
        let lightNode = SCNNode()
        lightNode.name = "Light node"
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        addNode(lightNode, to: scene.rootNode)

        //: ## Add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.name = "Ambient Light Node"
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        addNode(ambientLightNode, to: scene.rootNode)
        
        //: ## Add an axis at (0, 0, 0). this is the world origin.
        if let xyzAxis = Model.axis.createNode() {
            xyzAxis.name = "World Origin Axis"
            addNode(xyzAxis, to: scene.rootNode)
        }
        
        //: ## Add a fox at (0, 0, 0)
        if let foxNode = Model.fox.createNode() {
            foxNode.name = "Sparky 🦊"
            addNode(foxNode, to: scene.rootNode)
        }

        //: ## Add another fox, and move it around
        if let anotherFox = Model.fox.createNode() {
            
            anotherFox.name = "Mythos 🦊"
            anotherFox.position = SCNVector3Make(-0.03, 0, 0)
            anotherFox.scale = SCNVector3Make(0.8, 0.8, 0.8)
            anotherFox.eulerAngles = SCNVector3Make(0, 17, 45).degreesToRadians
            addNode(anotherFox, to: scene.rootNode)
            
            //: ## Animate the second fox
            anotherFox.runAction(
                SCNAction.repeatForever(
                    SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)))
        }
        
//        scene.rootNode.addChildNode(node)
        //#-end-editable-code
        
        //#-hidden-code
        

        scene.rootNode.updateFocusIfNeeded()
        
        return scene
    }
    
    public func addNode(_ node: SCNNode, to parentNode: SCNNode) {
        parentNode.addChildNode(node)
        
        nodeMetaDatas[node] = NodeMetaData(displayInHierachy: true)
        node.enumerateChildNodes { (child, _) in
            nodeMetaDatas[child] = NodeMetaData(displayInHierachy: false)
        }
        
        nodeMetaDatas[parentNode] = NodeMetaData(displayInHierachy: true)
    }
    
    public func removeNode(_ node: SCNNode?) {
        guard let node = node else { return }
        node.removeFromParentNode()
        node.enumerateHierarchy { (node, _) in
            nodeMetaDatas[node] = nil
        }
    }
    
    public func displayInHierachy(node: SCNNode) -> Bool {
        let metadata = nodeMetaDatas[node]
        return metadata?.displayInHierachy ?? true
    }
}
