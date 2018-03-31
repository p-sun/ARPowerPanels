//
//  SceneCreator.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-28.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import SceneKit

struct NodeMetaData {
    let modelType: Model
}

struct SceneCreator {
    private var nodeMetaDatas = [SCNNode: NodeMetaData]()

    mutating func createFoxPlaneScene() -> SCNScene {
       let scene = SCNScene(named: "art.scnassets/ship.scn")!

        //        // create and add a camera to the scene
        //        let cameraNode = SCNNode()
        //        cameraNode.camera = SCNCamera()
        //        scene.rootNode.addChildNode(cameraNode)
        //
        //        // place the camera
        //        cameraNode.position = SCNVector3(x: 3000, y: 0, z: 300)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        let foxNode = Model.fox.createNode()
        scene.rootNode.addChildNode(foxNode)
        nodeMetaDatas[foxNode] = NodeMetaData(modelType: .fox)

        // Animate the 3d object
         foxNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
//        let anotherFoxModel = Model.fox.createNode()
//        scene.rootNode.addChildNode(anotherFoxModel)
//        anotherFoxModel.position = SCNVector3Make(1, 1, 1)
//        nodeMetaDatas[anotherFoxModel] = NodeMetaData(modelType: .fox)
        
        scene.rootNode.updateFocusIfNeeded()

        return scene
    }
    
    func isNodeParentModel(node: SCNNode) -> Bool {
        return nodeMetaDatas[node] != nil
    }
}

