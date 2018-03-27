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

    var panelPresentor: RightPanelsPresenter!
    let transformationPanel = TransformationPanel(controlTypes: TransformationType.minimum)
    
    let purplePanel = UIView()
    let greenPanel = UIView()
    var verticalMenuItems = [MenuItem]()
    let verticalMenu = MenuStack(axis: .vertical)
    
    let arPanel = UIView()
    let gamePanel = UIView()
    var mainModeMenuItems = [MenuItem]()
    let mainMenuStack = MenuStack(axis: .horizontal)
    var isCurrentModeAR = true
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        panelPresentor = RightPanelsPresenter(presentingView: view)
        panelPresentor.delegate = self
        
        purplePanel.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        greenPanel.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        arPanel.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        gamePanel.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        
        mainModeMenuItems = [
            MenuItem(name: "AR Mode",
                     viewToPresent: arPanel,
                     menuTapped: { [weak self] in
                        // THIS can be refactored into MenuStack
                        if let strongSelf = self, !strongSelf.isCurrentModeAR {
                            strongSelf.isCurrentModeAR = true
                        }
                        self?.displayMainMode()
            }),
            MenuItem(name: "Game Mode",
                     viewToPresent: gamePanel,
                     menuTapped: { [weak self] in
                        if let strongSelf = self, strongSelf.isCurrentModeAR {
                            strongSelf.isCurrentModeAR = false
                        }
                        self?.displayMainMode()
            })
        ]

        verticalMenuItems = [
            MenuItem(name: "PURPLE",
                     viewToPresent: purplePanel,
                     menuTapped: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.panelPresentor.togglePanel(viewToPresent: strongSelf.purplePanel,
                                                      heightPriority: 0,
                                                      width: 400)
            }),
            MenuItem(name: "GREEN",
                     viewToPresent: greenPanel,
                     menuTapped: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.panelPresentor.togglePanel(viewToPresent: strongSelf.greenPanel,
                                                      heightPriority: 1,
                                                      width: 400)
            }),
            MenuItem(name: "TRANSFORMATION",
                     viewToPresent: transformationPanel,
                     menuTapped: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.panelPresentor.togglePanel(viewToPresent: strongSelf.transformationPanel,
                                                      heightPriority: 2,
                                                      width: 400)
            })
        ]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        transformationPanel.control(foxNode)
        
        greenPanel.constrainHeight(600, priority: .init(700))
        
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

        setupMainModeMenu()
        displayMainMode()
        
        setupVerticalMenuStack()
    }
    
    private func displayMainMode() {
        mainModeMenuItems[0].isSelected = isCurrentModeAR
        mainModeMenuItems[1].isSelected = !isCurrentModeAR
        mainMenuStack.configure(menuItems: mainModeMenuItems)
    }
}

extension ComponentsViewController: MenuStackDelegate {
    private func setupMainModeMenu() {
        mainMenuStack.menuStackDelegate = self
        mainMenuStack.configure(menuItems: mainModeMenuItems)
        view.addSubview(mainMenuStack)
        mainMenuStack.constrainTop(to: view, offset: 40)
        mainMenuStack.constrainLeading(to: view, offset: 30)
        mainMenuStack.constrainWidth(260)
        mainMenuStack.constrainHeight(60)
    }
    
    private func setupVerticalMenuStack() {
        verticalMenu.menuStackDelegate = self
        verticalMenu.configure(menuItems: verticalMenuItems)
        view.addSubview(verticalMenu)
        verticalMenu.constrainTopToBottom(of: mainMenuStack, offset: 20)
        verticalMenu.constrainLeading(to: view, offset: 30)
        verticalMenu.constrainBottom(to: view, offset: 30)
        verticalMenu.constrainWidth(200)
    }
    
    func menuStack(_ menuStack: MenuStack, didSelectAtIndex index: Int) {
        if menuStack == self.verticalMenu {
            verticalMenuItems[index].menuTapped()
        } else {
            mainModeMenuItems[index].menuTapped()
        }
    }
}

extension ComponentsViewController: RightPanelsPresenterDelegate {
    func rightPanelsPresenter(didPresent view: UIView) {
        let menuItemWithPresentedView = verticalMenuItems.first { $0.viewToPresent == view }
        menuItemWithPresentedView?.isSelected = true
        verticalMenu.configure(menuItems: verticalMenuItems)
    }
    
    func rightPanelsPresenter(didDismiss view: UIView) {
        let menuItemWithDismissedView = verticalMenuItems.first { $0.viewToPresent == view }
        menuItemWithDismissedView?.isSelected = false
        verticalMenu.configure(menuItems: verticalMenuItems)
    }
}
