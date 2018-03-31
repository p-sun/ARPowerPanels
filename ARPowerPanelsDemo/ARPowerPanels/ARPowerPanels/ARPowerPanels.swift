//
//  ARPowerPanels.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-28.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PowerPanelScene: SCNScene {

    var shouldShowCamera: Bool = true

    override var background: SCNMaterialProperty {
        get {
            if shouldShowCamera {
                print("SCENE background \(super.background)")
                return super.background
            } else {
                print("SCENE background -- none")
                return SCNMaterialProperty()
            }
        }
    }
}

protocol HasSelectedNode {
    func selectedSCNNode() -> SCNNode?
}

protocol ARPowerPanelsDataSource: HierachyIteratorDataSource { }

class ARPowerPanels: UIView {
    
    var selectedNode: SCNNode? {
        didSet {
            guard let selectedNode = selectedNode else { return }

            oldValue?.setGlow(false)
            selectedNode.setGlow(true)

            updatePanels()
        }
    }
    
    weak var dataSource: ARPowerPanelsDataSource? {
        didSet {
            updatePanels()
        }
    }
    
    // MARK: Right-hand panels
    private let purplePanel = PurpleView()
    private let greenPanel = GreenView()
    private let transformationPanel = TransformationPanel(controlTypes: TransformationType.transformations)
    private let hierachyPanel: HierachyPanel
    private let infoPanel =  TransformationPanel(controlTypes: TransformationType.entityInfo)
    
    // MARK: Left hand views
    private let showHideMenuButton = RoundedButton()
    private let selectedNodeLabel = UILabel()
    private var menuItems = [MenuItem]()
    private let menuStack = MenuStack(axis: .vertical)
    
    // MARK: Background views
    private let scene: SCNScene
    private var panelPresentor: PanelsPresenter!
    
    private let sceneViewParent = UIView()
    private let sceneView = SCNView()
    
    private var arSceneView: ARSCNView?
    private let gameModeCameraNode = SCNNode()

    private let rootNode: SCNNode // TODO refactor
    
    convenience init(scene: SCNScene) {
        self.init(scene: scene, rootNode: scene.rootNode, isARKit: false)
        sceneView.backgroundColor = #colorLiteral(red: 0.1654644267, green: 0.3628849843, blue: 0.5607843399, alpha: 1) // TODO change color
    }
    
    convenience init(arSceneView: ARSCNView, scene: SCNScene) {
        
        
//        let newScene = SCNScene()
////        newScene.background = SCNMaterialProperty(UIColor.purple) // GET ONLY
////        for child in scene.rootNode.childNodes { // TODO move to function
////            print("adding child \(child)")
////            newScene.rootNode.addChildNode(child)
////        }
//
//        newScene.rootNode.addChildNode(scene.rootNode)
//
//
//
//////        for childrenInARScene in scene.rootNode.childNodes {
////            newScene.rootNode.addChildNode(scene.rootNode)
//////        }
//        self.init(scene: newScene, rootNode: newScene.rootNode, isARKit: true) // not sure why i can't do scene.rootnode


        self.init(scene: scene, rootNode: scene.rootNode, isARKit: true) // not sure why i can't do scene.rootnode

//        self.arSceneView = arSceneView
        
        // Select AR Mode (i.e. hide the GameMode)
        sceneViewParent.isHidden = true
        
        
        // Brakes if the user pans the scene
        let cameraParent = SCNNode()
        rootNode.addChildNode(cameraParent)
        cameraParent.position = SCNVector3(x: 0, y: 3, z: 13)

        gameModeCameraNode.name = "GameMode Camera"
        gameModeCameraNode.camera = SCNCamera()
        cameraParent.addChildNode(gameModeCameraNode)
        
        print("camera initialized \(cameraParent)")
        // place the camera
        sceneView.pointOfView = gameModeCameraNode

        
        
        // create and add a camera to the scene
//        gameModeCameraNode.name = "GameMode Camera"
//        gameModeCameraNode.camera = SCNCamera()
//        rootNode.addChildNode(gameModeCameraNode)
//        gameModeCameraNode.position = SCNVector3(x: 0, y: 3, z: 13)
//        print("camera initialized \(gameModeCameraNode)")
//        // place the camera
//        sceneView.pointOfView = gameModeCameraNode

        sceneView.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
    }
    
    private init(scene: SCNScene, rootNode: SCNNode, isARKit: Bool) {
        self.scene = scene
        self.rootNode = rootNode
        hierachyPanel = HierachyPanel()

        super.init(frame: CGRect.zero)

        
        // Init variables
        menuItems = [
            MenuItem(name: "SCENE GRAPH", panelItem: PanelItem(viewToPresent: hierachyPanel, heightPriority: .init(400), preferredHeight: 440, width: 400)),
            MenuItem(name: "INFO", panelItem: PanelItem(viewToPresent: infoPanel, heightPriority: .init(1000), preferredHeight: nil, width: 400)),
            MenuItem(name: "TRANSFORMATION", panelItem: PanelItem(viewToPresent: transformationPanel, heightPriority: .init(1000), preferredHeight: nil, width: 400)),

            MenuItem(name: "PURPLE", panelItem: PanelItem(viewToPresent: purplePanel, heightPriority: .init(250), preferredHeight: 400, width: 400)),
            MenuItem(name: "GREEN", panelItem: PanelItem(viewToPresent: greenPanel, heightPriority: .init(300), preferredHeight: 600, width: 400)),
        ]

        // Setup background
        setupSceneView()

        panelPresentor = PanelsPresenter(presentingView: self)
        panelPresentor.delegate = self
        
        // Setup left-hand menu
//        if isARKit { //TODO
            setupARGameModeSegmentedControl()
//        }
        setupSelectedNodeLabel()
        setupShowHideMenuButton()
        setupVerticalMenuStack()
 
        // Setup right-hand panels
        hierachyPanel.delegate = self
        hierachyPanel.dataSource = self
        transformationPanel.transformationDelegate = self
        infoPanel.transformationDelegate = self
        
        // Set the selected node, and update all the panels to control this node
        selectedNode = scene.rootNode
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectNode(_ node: SCNNode) {
        self.selectedNode = node
    }
    
    private func updatePanels() {
        updateSelectedNodeLabel()
        if let selectedNode = selectedNode { // TODO Display error if no node was selected
            transformationPanel.control(selectedNode)
            infoPanel.control(selectedNode)
        }
        hierachyPanel.renderHierachy()
    }
    
    private func setupSceneView() {
        sceneViewParent.backgroundColor = #colorLiteral(red: 0.0003343143538, green: 0.03833642512, blue: 0.4235294163, alpha: 1)
        addSubview(sceneViewParent)
        sceneViewParent.constrainEdges(to: self)
        
        sceneView.allowsCameraControl = true // allows the user to manipulate the camera
        sceneView.setupGlowEffect()
        //        sceneView.showsStatistics = true
        sceneView.scene = scene
        sceneViewParent.addSubview(sceneView)
        sceneView.constrainEdges(to: sceneViewParent)
    }
    
    private func setupSelectedNodeLabel() {
        selectedNodeLabel.font = UIFont.gameModelLabel
        selectedNodeLabel.textColor = UIColor.uiControlColor
        addSubview(selectedNodeLabel)
        selectedNodeLabel.constrainTop(to: self, offset: 100)
        selectedNodeLabel.constrainLeft(to: self, offset: 30)
    }
    
    private func updateSelectedNodeLabel() {
        if let selectedNode = selectedNode {
            selectedNodeLabel.text = "Selected node: \(selectedNode.displayName)"
        } else {
            selectedNodeLabel.text = nil
        }
    }
}

extension ARPowerPanels {
    func setupARGameModeSegmentedControl() {
        let segmentedControl = UISegmentedControl(items: ["AR", "Game"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.inputSliderHeader],
                                                for: .normal)
        self.addSubview(segmentedControl)
        segmentedControl.constrainTop(to: self, offset: 40)
        segmentedControl.constrainLeading(to: self, offset: 30)
        segmentedControl.constrainSize(CGSize(width: 200, height: 30))
        segmentedControl.tintColor = .uiControlColor
        segmentedControl.addTarget(self, action: #selector(segmentSelected), for: .valueChanged)
    }
    
    @objc private func segmentSelected(_ segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 { // AR MODE
            sceneViewParent.isHidden = true
            if let powerScene = sceneView.scene as? PowerPanelScene {
                powerScene.shouldShowCamera = true
//                print("Current power camera node \(powerScene.background)")

            }
//            arSceneView?.isHidden = false
        } else { // GAME Mode
            sceneViewParent.isHidden = false
//            arSceneView?.isHidden = true
//            sceneView.pointOfView = gameModeCameraNode
  
            
//            print("Current camera node \(sceneView.scene?.background)")

            if let powerScene = sceneView.scene as? PowerPanelScene {
                powerScene.shouldShowCamera = false
//                print("Current power camera node \(powerScene.background)")

            }
            
//            <SCNMaterialProperty: 0x1c00da010 | contents=(null)>

//            sceneView.scene?.setb
//            print("Current camera node \(sceneView.scene?.background)")

            print("Current camera node \(sceneView.pointOfView)")

            
//            arSceneView?.scene = SCNScene()
            
        }
    }
}

extension ARPowerPanels: RoundedButtonDelegate {
    private func setupShowHideMenuButton() {
        showHideMenuButton.delegate = self
        showHideMenuButton.isSelected = true
        showHideMenuButton.setTitle("☰")
        addSubview(showHideMenuButton)
        showHideMenuButton.constrainTopToBottom(of: selectedNodeLabel, offset: 20)
        showHideMenuButton.constrainLeading(to: self, offset: 30)
        showHideMenuButton.constrainSize(CGSize(width: 44, height: 44))
    }
    
    func roundedButton(didTap button: RoundedButton) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.menuStack.alpha = button.isSelected ? 1 : 0
        }
    }
}

extension ARPowerPanels: MenuStackDelegate {
    private func setupVerticalMenuStack() {
        menuStack.menuStackDelegate = self
        menuStack.configure(menuItems: menuItems.map({ $0.stackItem }))
        self.addSubview(menuStack)
        menuStack.constrainTopToBottom(of: showHideMenuButton, offset: 10)
        menuStack.constrainLeading(to: self, offset: 30)
        menuStack.constrainBottom(to: self, offset: 30)
        menuStack.constrainWidth(200)
    }
    
    func menuStack(_ menuStack: MenuStack, didSelectAtIndex index: Int) {
        if menuStack == self.menuStack {
            panelPresentor.togglePanel(panelItem: menuItems[index].panelItem)
        }
    }
}

extension ARPowerPanels: PanelsPresenterDelegate {
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

extension ARPowerPanels: TransformationPanelDelegate {
    func transformationPanelDidChangeNodeName() {
        updateSelectedNodeLabel()
        hierachyPanel.renderHierachy()
    }
}

extension ARPowerPanels: HierachyPanelDelegate {
    func hierachyPanel(didSelectNode node: SCNNode) {
        selectedNode = node
    }
}

extension ARPowerPanels: HierachyPanelDataSource {
    func rootNodeForHierachy() -> SCNNode {
        return rootNode
    }
    
    func hierachyPanel(shouldDisplayChildrenFor node: SCNNode) -> Bool {
        return dataSource?.hierachyPanel(shouldDisplayChildrenFor: node) ?? true
    }
}

extension ARPowerPanels: HasSelectedNode {
    func selectedSCNNode() -> SCNNode? {
        return selectedNode
    }
}
