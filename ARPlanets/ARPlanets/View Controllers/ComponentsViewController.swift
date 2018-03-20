//
//  ComponentsViewController.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit

class ComponentsViewController: UIViewController {
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        view.backgroundColor = .white
        
//        let inputView = SlidingInputView() { value in
//            print("value did change \(value)")
//        }
//        view.addSubview(inputView)
//        inputView.constrainCenterX(to: view)
//        inputView.constrainCenterY(to: view)
//        inputView.constrainWidth(200)
        
        
        let inputView = SlidingVector3View(labelTexts: ["x:", "  y:", "  z:"])
        view.addSubview(inputView)
        inputView.constrainCenterX(to: view)
        inputView.constrainCenterY(to: view)
        inputView.constrainWidth(400)
    }
}
