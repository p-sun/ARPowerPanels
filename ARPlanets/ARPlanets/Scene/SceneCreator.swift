//
//  SceneCreator.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-28.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import SceneKit

struct SceneCreator {
    
    static func createFoxPlaneScene() -> SCNScene {
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

        // animate the 3d object
        //        foxNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        scene.rootNode.addChildNode(foxNode)
        scene.rootNode.updateFocusIfNeeded()

        return scene
    }
    
}

