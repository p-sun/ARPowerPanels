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

    var foxNode = Model.fox.createNode()

    var panelPresentor: RightPanelsPresenter!
    let transformationPanel = TransformationPanel(controlTypes: TransformationType.minimum)
    
    var menuItems = [MenuItem]()
    let menuStack = MenuStack(axis: .vertical)
    
    let arPanel = UIView()
    let gamePanel = UIView()
    let purplePanel = PurpleView()
    let greenPanel = GreenView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        panelPresentor = RightPanelsPresenter(presentingView: view)
        panelPresentor.delegate = self
        
        arPanel.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        gamePanel.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        
        menuItems = [
            MenuItem(name: "PURPLE", panelItem: PanelItem(viewToPresent: purplePanel, heightPriority: .init(250), preferredHeight: 400, width: 400)),
            MenuItem(name: "GREEN", panelItem: PanelItem(viewToPresent: greenPanel, heightPriority: .init(300), preferredHeight: 600, width: 400)),
            MenuItem(name: "TRANSFORMATION", panelItem: PanelItem(viewToPresent: transformationPanel, heightPriority: .init(1000), preferredHeight: nil, width: 400))
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        transformationPanel.control(foxNode)
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
        

        // animate the 3d object
//        foxNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        scene.rootNode.addChildNode(foxNode)
        scene.rootNode.updateFocusIfNeeded()


        // Add glow effect
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

//        scene.rootNode.enumerateHierarchy({ (node: SCNNode, _: UnsafeMutablePointer<ObjCBool>) in
//            print(node.name)
////            guard let particles = node.particleSystems else { return }
////            for particle in particles {
        ////                enemy.addParticleSystem(particle)
        ////            }
        //        })
        
        setupARGameModeSegmentedControl()
        setupVerticalMenuStack()
    }
}

extension ComponentsViewController {
    func setupARGameModeSegmentedControl() {
        let segmentedControl = UISegmentedControl(items: ["AR", "Game"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.inputSliderHeader],
                                                for: .normal)
        view.addSubview(segmentedControl)
        segmentedControl.constrainTop(to: view, offset: 40)
        segmentedControl.constrainLeading(to: view, offset: 30)
        segmentedControl.constrainSize(CGSize(width: 200, height: 30))
        segmentedControl.tintColor = .uiControlColor
        segmentedControl.addTarget(self, action: #selector(segmentSelected), for: .valueChanged)
    }
    
    @objc private func segmentSelected(_ segmentedControl: UISegmentedControl) {
        print("segmeted control \(segmentedControl.selectedSegmentIndex)")
    }
}

extension ComponentsViewController: MenuStackDelegate {
    private func setupVerticalMenuStack() {
        menuStack.menuStackDelegate = self
        menuStack.configure(menuItems: menuItems.map({ $0.stackItem }))
        view.addSubview(menuStack)
        menuStack.constrainTop(to: view, offset: 110)
        menuStack.constrainLeading(to: view, offset: 30)
        menuStack.constrainBottom(to: view, offset: 30)
        menuStack.constrainWidth(200)
    }
    
    func menuStack(_ menuStack: MenuStack, didSelectAtIndex index: Int) {
        if menuStack == self.menuStack {
            panelPresentor.togglePanel(panelItem: menuItems[index].panelItem)
        }
    }
}

extension ComponentsViewController: RightPanelsPresenterDelegate {
    func rightPanelsPresenter(didPresent view: UIView) {
        let menuItemWithPresentedView = menuItems.first { $0.panelItem.viewToPresent == view }
        menuItemWithPresentedView?.stackItem.isSelected = true
        menuStack.configure(menuItems: menuItems.map({ $0.stackItem }))
    }
    
    func rightPanelsPresenter(didDismiss view: UIView) {
        let menuItemWithDismissedView = menuItems.first { $0.panelItem.viewToPresent == view }
        menuItemWithDismissedView?.stackItem.isSelected = false
        menuStack.configure(menuItems: menuItems.map({ $0.stackItem }))
    }
}
