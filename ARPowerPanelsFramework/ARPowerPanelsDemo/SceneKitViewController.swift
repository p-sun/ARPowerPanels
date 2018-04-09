//
//  SceneKitViewController.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import SceneKit
import ARPowerPanels

class SceneKitViewController: UIViewController {
    
    var powerPanels: ARPowerPanels
    
    let scene = SCNScene()

    init() {
        powerPanels = ARPowerPanels(scene: scene, panelTypes: [.info, .easyMoves, .sceneGraph])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        powerPanels.selectNode(scene.rootNode)
        view.addSubview(powerPanels)
        powerPanels.constrainEdges(to: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
