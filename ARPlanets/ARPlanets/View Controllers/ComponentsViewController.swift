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
        
        let label = SlidingInputView()
        view.addSubview(label)
        label.backgroundColor = .green
        label.constrainCenterX(to: view)
        label.constrainCenterY(to: view)
        label.constrainWidth(200)
    }
}
