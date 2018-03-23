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
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let inputView = SlidingVector3View(minValue: -200, maxValue: 200)
        view.addSubview(inputView)
        inputView.constrainCenterX(to: view)
        inputView.constrainCenterY(to: view)
        inputView.constrainWidth(460)
        
        inputView.delegate = self
    }
}

extension ComponentsViewController: SlidingVector3ViewDelegate {
    func slidingVector3View(didChangeValues vector: SCNVector3) {
        print(vector)
    }
}
