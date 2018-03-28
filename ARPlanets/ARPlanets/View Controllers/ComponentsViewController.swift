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

    var sudoARView: SudoARView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = #colorLiteral(red: 0.7060456284, green: 1, blue: 0.8839808301, alpha: 1)
        
//        arPanel.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
//        gamePanel.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SceneCreator.createFoxPlaneScene()
        sudoARView = SudoARView(scene: scene)
        view.addSubview(sudoARView)
        sudoARView.constrainEdges(to: view)
        
//        transformationPanel.control(foxNode)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Add glow effect
//        if let foxModel = foxNode.childNode(withName: "Max", recursively: true) {
//            foxModel.categoryBitMask = 2
//        }
//
//        if let path = Bundle.main.path(forResource: "NodeTechnique", ofType: "plist") {
//            if let dict = NSDictionary(contentsOfFile: path)  {
//                let dict2 = dict as! [String : AnyObject]
//                let technique = SCNTechnique(dictionary:dict2)
//                sceneView.technique = technique
//            }
//        }

//        scene.rootNode.enumerateHierarchy({ (node: SCNNode, _: UnsafeMutablePointer<ObjCBool>) in
//            print(node.name)
////            guard let particles = node.particleSystems else { return }
////            for particle in particles {
        ////                enemy.addParticleSystem(particle)
        ////            }
        //        })
        

    }
}

