//
//  ComponentsViewController.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import SceneKit

class ComponentsViewController: UIViewController {
    
    var foxNode = Model.fox.createNode()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.7060456284, green: 1, blue: 0.8839808301, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // create and add a camera to the scene
        let sceneView = SCNView()
        //        let sceneView = view as! SCNView
        sceneView.allowsCameraControl = true // allows the user to manipulate the camera
        sceneView.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
//        sceneView.showsStatistics = true
        
        view.addSubview(sceneView)
        sceneView.constrainEdges(to: view)
        
        // set the scene to the view
        //let scene = SCNScene()
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = scene
        
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
        
        // animate the 3d object
//        foxNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        foxNode.scale = SCNVector3Make(10, 10, 10)
        scene.rootNode.addChildNode(foxNode)

        let inputView = SlidingNodeTransformView()
//        inputView.delegate = self
        view.addSubview(inputView)
        inputView.constrainCenterX(to: view)
        inputView.constrainCenterY(to: view)
        inputView.constrainEdgesHorizontally(to: view, leftInsets: 40, rightInsets: 40)
        inputView.configure(for: foxNode)
    }
}

//extension ComponentsViewController: SlidingNodeTransformViewDelegate {
//    func slidingNodeTransformView(positionDidChange position: SCNVector3) {
//        foxNode.position = position
//    }
//    func slidingNodeTransformView(rotationDidChange rotation: SCNVector4) {
//        foxNode.rotation = rotation
//    }
//    func slidingNodeTransformView(scaleDidChange scale: SCNVector3) {
//        foxNode.scale = scale
//    }
//}

