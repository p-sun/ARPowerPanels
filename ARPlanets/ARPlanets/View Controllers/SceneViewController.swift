//
//  ViewController.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class SceneViewController: UIViewController {

    // MARK: Variables
    private var sceneView = ARSCNView()
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sceneView)
        sceneView.constrainEdges(to: view)
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions  = [.showConstraints, ARSCNDebugOptions.showFeaturePoints]
        
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        beginSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    private func beginSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
}

extension UIViewController: ARSCNViewDelegate {
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    public func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    public func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    public func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
