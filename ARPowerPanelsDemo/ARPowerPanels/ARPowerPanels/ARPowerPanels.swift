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

protocol ARPowerPanelsDataSource: class {
    func powerPanel(shouldDisplayChildrenFor node: SCNNode) -> Bool
}

class ARPowerPanels: UIView {
    
    var selectedNode: SCNNode? {
        didSet {
            guard let selectedNode = selectedNode else { return }

            oldValue?.setGlow(false)
            
            // Don't glow ARSCNView.rootNode, because it doesn't work well with
            // debug feature points and planes don't work well.
            if selectedNode.name?.contains("World Origin") == false {
                selectedNode.setGlow(true)
            }

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
    private let hierachyPanel: HierachyPanel
    
    private let infoPanel = TransformationPanel(controlTypes: TransformationType.entityInfo)
    private let easyMovePanel = TransformationPanel(controlTypes: TransformationType.easyMove)
    private let advancedMovePanel = TransformationPanel(controlTypes: TransformationType.advancedMove)
    private let allEditsPanel = TransformationPanel(controlTypes: TransformationType.all)
    
    // MARK: Left hand views
    private let showHideMenuButton = RoundedButton()
    private let selectedNodeLabel = UILabel()
    private var menuItems = [MenuItem]()
    private let menuStack = MenuStack(axis: .vertical)
    
    // MARK: Background views
    private var panelPresentor: PanelsPresenter!
    
    private let sceneViewParent = UIView()
    private let sceneView = SCNView()
    
    private var arSceneView: ARSCNView?
    
    private let cameraParent = SCNNode()
    private let gameModeCameraNode = SCNNode()

    private var rootNode: SCNNode { // TODO refactor
        didSet {
            updatePanels()
        }
    }
    
    convenience init(scene: SCNScene) { //TODO
        self.init(rootNode: scene.rootNode, isARKit: false)
        sceneView.backgroundColor = #colorLiteral(red: 0.1654644267, green: 0.3628849843, blue: 0.5607843399, alpha: 1) // TODO change color
        
        sceneView.scene = scene
        
        // Set the selected node, and update all the panels to control this node
        selectedNode = scene.rootNode
    }
    
    convenience init(arSceneView: ARSCNView, scene: SCNScene) {
        self.init(rootNode: arSceneView.scene.rootNode, isARKit: true)
        self.arSceneView = arSceneView
        arSceneView.setupGlowTechnique()
        
        // Select AR Mode (i.e. hide the GameMode)
        sceneViewParent.isHidden = true
        
        // Set the selected node, and update all the panels to control this node
        selectedNode = arSceneView.scene.rootNode
    }
    
    private init(rootNode: SCNNode, isARKit: Bool) {
        self.rootNode = rootNode
        hierachyPanel = HierachyPanel()

        super.init(frame: CGRect.zero)
        
        // Init variables
        menuItems = [
            MenuItem(name: "SCENE GRAPH", panelItem: PanelItem(viewToPresent: hierachyPanel, heightPriority: .init(400), preferredHeight: 440, width: 400)),
            MenuItem(name: "INFO", panelItem: PanelItem(viewToPresent: infoPanel, heightPriority: .init(1000), preferredHeight: nil, width: 400)),
            MenuItem(name: "EASY MOVES", panelItem: PanelItem(viewToPresent: easyMovePanel, heightPriority: .init(999), preferredHeight: nil, width: 400)),
            MenuItem(name: "ALL MOVES", panelItem: PanelItem(viewToPresent: advancedMovePanel, heightPriority: .init(998), preferredHeight: nil, width: 400)),
            MenuItem(name: "ALL EDITS", panelItem: PanelItem(viewToPresent: allEditsPanel, heightPriority: .init(997), preferredHeight: nil, width: 400)),
            MenuItem(name: "PURPLE", panelItem: PanelItem(viewToPresent: purplePanel, heightPriority: .init(250), preferredHeight: 400, width: 400)),
            MenuItem(name: "GREEN", panelItem: PanelItem(viewToPresent: greenPanel, heightPriority: .init(300), preferredHeight: 600, width: 400)),
        ]

        // Setup background
        constrainSceneView()

        panelPresentor = PanelsPresenter(presentingView: self)
        panelPresentor.delegate = self
        
        // Setup left-hand menu
        if isARKit {
            setupARGameModeSegmentedControl()
        }
        setupSelectedNodeLabel()
        setupShowHideMenuButton()
        setupVerticalMenuStack()
 
        // Setup right-hand panels
        hierachyPanel.delegate = self
        hierachyPanel.dataSource = self
        
        infoPanel.transformationDelegate = self
        easyMovePanel.transformationDelegate = self
        advancedMovePanel.transformationDelegate = self
        allEditsPanel.transformationDelegate = self
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
            infoPanel.control(selectedNode) // TODO refactor all these Transformation panels
            easyMovePanel.control(selectedNode)
            advancedMovePanel.control(selectedNode)
            allEditsPanel.control(selectedNode)
        }
        hierachyPanel.renderHierachy()
    }
    
    private func constrainSceneView() {
        sceneViewParent.backgroundColor = #colorLiteral(red: 0.0003343143538, green: 0.03833642512, blue: 0.4235294163, alpha: 1)
        addSubview(sceneViewParent)
        sceneViewParent.constrainEdges(to: self)
        
        sceneView.allowsCameraControl = true // allows the user to manipulate the camera
        sceneView.setupGlowTechnique()
        //        sceneView.showsStatistics = true
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
            // If the user drags the screen, then another invisible camera will be the new pointOfView
            // If that happened, save the new camera's transform. TODO
            //            if let currentCamera = sceneView.pointOfView {
            //                print("current camera position \(currentCamera.position) \(currentCamera.rotation)")
            //                gameModeCameraNode.transform = currentCamera.transform
            //            }
            
            if let arSceneView = arSceneView {
                let newScene = SCNScene()
                newScene.rootNode.name = "AR World Origin   🌎"

                for child in rootNode.childNodes {
                    let newChild = child
                    child.removeFromParentNode()
                    newScene.rootNode.addChildNode(newChild)
                }
                arSceneView.scene = newScene
                rootNode = newScene.rootNode

                if selectedNode?.parent == sceneView.scene?.rootNode {
                    selectedNode = newScene.rootNode
                }

                sceneView.scene = nil
            }

        } else { // GAME Mode
            sceneViewParent.isHidden = false
            
            if let  arSceneView = arSceneView {
                let newScene = SCNScene()
                sceneView.scene = newScene
                newScene.rootNode.name = "SceneView World Origin   🌎"
                
                // Doing this will break the ARSCNView, that's why we have to
                // create a new scene when we switch back to AR mode
                let arSceneRootNode = arSceneView.scene.rootNode
                newScene.rootNode.addChildNode(arSceneRootNode)
                
                setupSceneView(sceneView: sceneView)
                rootNode = arSceneRootNode
            }
        }
    }
    
    private func setupSceneView(sceneView: SCNView) {
        
        // TODO Fix: Camera control is broken when the user pans the scene
        // Need to give control back to the ARScene
        sceneView.scene!.rootNode.addChildNode(cameraParent)
        cameraParent.position = SCNVector3(x: 0, y: 3, z: 13)
        
        gameModeCameraNode.name = "GameMode Camera"
        gameModeCameraNode.camera = SCNCamera()
        cameraParent.addChildNode(gameModeCameraNode)
        
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
            let panelItem = menuItems[index].panelItem
            panelPresentor.togglePanel(panelItem: panelItem)

            if panelItem.viewToPresent == hierachyPanel {
                hierachyPanel.renderHierachy()
            }
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
        return dataSource?.powerPanel(shouldDisplayChildrenFor: node) ?? true
    }
    
    func selectedForHierachyPanel() -> SCNNode? {
        return selectedNode
    }
}
