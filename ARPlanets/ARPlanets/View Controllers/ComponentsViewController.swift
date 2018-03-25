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


    let panelPresentor = RightPanelPresenter()
    let transformationPanel = TransformationPanel(controlTypes: [.opacity, .position, .scale, .orientation])
    
    let purplePanel = UIView()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        transformationPanel.control(foxNode)

        purplePanel.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        view.backgroundColor = #colorLiteral(red: 0.7060456284, green: 1, blue: 0.8839808301, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // create and add a camera to the scene
        let sceneView = SCNView()
        //        let sceneView = view as! SCNView
        sceneView.allowsCameraControl = true // allows the user to manipulate the camera
        sceneView.backgroundColor = #colorLiteral(red: 0.0003343143538, green: 0.03833642512, blue: 0.4235294163, alpha: 1)
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
        
        let button = UIButton()
        button.setTitle("PANEL", for: UIControlState.normal)
        button.addTarget(self, action: #selector(togglePanel), for: UIControlEvents.touchUpInside)
        view.addSubview(button)
        button.constrainLeft(to: view, offset: 30)
        button.constrainBottom(to: view, offset: -30)
        
        let button2 = UIButton()
        button2.setTitle("VIEW", for: UIControlState.normal)
        button2.addTarget(self, action: #selector(togglePanel2), for: UIControlEvents.touchUpInside)
        view.addSubview(button2)
        button2.constrainLeft(to: view, offset: 30)
        button2.constrainBottom(to: view, offset: -70)

        
        // animate the 3d object
//        foxNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        scene.rootNode.addChildNode(foxNode)
        scene.rootNode.updateFocusIfNeeded()

        
//        view.addSubview(inputView)
//        inputView.constrainCenterX(to: view)
//        inputView.constrainCenterY(to: view)
//        inputView.constrainEdgesHorizontally(to: view, leftInsets: 40, rightInsets: 40)


        if let foxModel = foxNode.childNode(withName: "Max", recursively: true) {
            foxModel.categoryBitMask = 2
        }
        
        if let path = Bundle.main.path(forResource: "NodeTechnique", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path)  {
                let dict2 = dict as! [String : AnyObject]
                let technique = SCNTechnique(dictionary:dict2)
                sceneView.technique = technique
            }
        }
    }
    
    @objc func togglePanel2() {
        panelPresentor.togglePanel(newPresentedView: purplePanel, presentingView: view, width: 400)
    }
    
    @objc func togglePanel() {
        panelPresentor.togglePanel(newPresentedView: transformationPanel, presentingView: view, width: 400)
    }
}
