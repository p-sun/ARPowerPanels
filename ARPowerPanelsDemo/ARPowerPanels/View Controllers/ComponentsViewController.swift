//
//  ComponentsViewController.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import SceneKit

class PurpleView: UIView {
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GreenView: UIView {
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ComponentsViewController: UIViewController {
    
//    let foxNode = SCNNode() // Temporarly

    var powerPanels: ARPowerPanels!
    
    var sceneCreator = SceneCreator()
    var scene: SCNScene!

    init() {
        super.init(nibName: nil, bundle: nil)
//        view.backgroundColor = #colorLiteral(red: 0.7060456284, green: 1, blue: 0.8839808301, alpha: 1)
//        arPanel.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
//        gamePanel.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = sceneCreator.createFoxPlaneScene()
        powerPanels = ARPowerPanels(scene: scene)
        powerPanels.dataSource = self
        view.addSubview(powerPanels)
        powerPanels.constrainEdges(to: view)
        
        powerPanels.selectNode(scene.rootNode)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension ComponentsViewController: ARPowerPanelsDataSource {
    func hierachyPanelScene() -> SCNScene {
        return scene
    }
    
    func hierachyPanel(shouldDisplay node: SCNNode) -> Bool {
        return sceneCreator.isNodeParentModel(node: node)
    }
}
