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

enum ARPowerPanelsType {
    case sceneGraph, info, easyMoves, allMoves, allEdits
    
    static var allTypes: [ARPowerPanelsType] {
        return [.sceneGraph, .info, .easyMoves, .allMoves, .allEdits]
    }
}

class ARPowerPanels: UIView {
    
    var selectedNode: SCNNode? {
        didSet {
            guard let selectedNode = selectedNode else { return }

            oldValue?.setGlow(false)
            
            // Don't glow ARSCNView.rootNode, because it doesn't work well with
            // debug feature points or planes
            if selectedNode.name?.contains("World Origin") == false {
                selectedNode.setGlow(true)
            }

            updatePanels()
        }
    }
    
    // MARK: Right-hand panels
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
    
    private let gameModeCameraNode = gameModeCameraMake()

    private var rootNode: SCNNode { // TODO refactor
        didSet {
            updatePanels()
        }
    }
    
    convenience init(scene: SCNScene, panelTypes: [ARPowerPanelsType]) { //TODO
        self.init(rootNode: scene.rootNode, isARKit: false, panelTypes: panelTypes)
        sceneView.backgroundColor = #colorLiteral(red: 0.1654644267, green: 0.3628849843, blue: 0.5607843399, alpha: 1) // TODO change color
        
        sceneView.scene = scene
        
        // Set the selected node, and update all the panels to control this node
        selectedNode = scene.rootNode
    }
    
    convenience init(arSceneView: ARSCNView, panelTypes: [ARPowerPanelsType]) {
        self.init(rootNode: arSceneView.scene.rootNode, isARKit: true, panelTypes: panelTypes)
        self.arSceneView = arSceneView
        arSceneView.setupGlowTechnique()
        
        // Select AR Mode (i.e. hide the GameMode)
        sceneViewParent.isHidden = true
        
        // Set the selected node, and update all the panels to control this node
        selectedNode = arSceneView.scene.rootNode
    }
    
    private init(rootNode: SCNNode, isARKit: Bool, panelTypes: [ARPowerPanelsType]) {
        self.rootNode = rootNode
        hierachyPanel = HierachyPanel()

        super.init(frame: CGRect.zero)
        
        // Init variables
        menuItems = panelTypes.map { menuForPanelType($0) }

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
    
    private func menuForPanelType(_ panelType: ARPowerPanelsType) -> MenuItem {
            switch panelType {
            case .sceneGraph:
                return MenuItem(name: "SCENE GRAPH", panelItem: PanelItem(viewToPresent: hierachyPanel, heightPriority: .init(400), preferredHeight: 440, width: 400))
            case .info:
                return MenuItem(name: "INFO", panelItem: PanelItem(viewToPresent: infoPanel, heightPriority: .init(1000), preferredHeight: nil, width: 400))
            case .easyMoves:
                return MenuItem(name: "EASY MOVES", panelItem: PanelItem(viewToPresent: easyMovePanel, heightPriority: .init(999), preferredHeight: nil, width: 400))
            case .allMoves:
                return MenuItem(name: "ALL MOVES", panelItem: PanelItem(viewToPresent: advancedMovePanel, heightPriority: .init(998), preferredHeight: nil, width: 400))
            case .allEdits:
                return MenuItem(name: "ALL EDITS", panelItem: PanelItem(viewToPresent: allEditsPanel, heightPriority: .init(997), preferredHeight: nil, width: 400))
            }
            //            MenuItem(name: "PURPLE", panelItem: PanelItem(viewToPresent: purplePanel, heightPriority: .init(250), preferredHeight: 400, width: 400)),
            //            MenuItem(name: "GREEN", panelItem: PanelItem(viewToPresent: greenPanel, heightPriority: .init(300), preferredHeight: 600, width: 400)),
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
        
        sceneView.backgroundColor = #colorLiteral(red: 0.0003343143538, green: 0.03833642512, blue: 0.4235294163, alpha: 1)
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
    
    @objc private func segmentSelected(_ segmentedControl: UISegmentedControl) { // TODO refactor
        
        // AR MODE *********************
        
        if segmentedControl.selectedSegmentIndex == 0 {
            sceneViewParent.isHidden = true
            
            // When we enter game mode, the user can tap the "Game Mode Camera" and adjust its position.
            // If the user drags the screen, then another invisible camera will be the new pointOfView.
            // To allow the "Game Mode Camera" to adjust the pointOfView again, exit to AR Mode, save the invisible camera's transform, and then come back to Game Mode.
            if let currentCamera = sceneView.pointOfView {
                gameModeCameraNode.transform = currentCamera.transform
            }
            
            if let arSceneView = arSceneView {
                let newScene = SCNScene()
                newScene.rootNode.name = "AR World Origin   🌎"

                for child in rootNode.childNodes {
                    let newChild = child
                    child.removeFromParentNode()
                    if child.name != "Game Mode Camera" {
                        newScene.rootNode.addChildNode(newChild)
                    }
                }
                arSceneView.scene = newScene
                rootNode = newScene.rootNode

                if selectedNode?.parent == sceneView.scene?.rootNode {
                    selectedNode = newScene.rootNode
                }

                sceneView.scene = nil
            }

        // GAME MODE *********************
            
        } else {
            sceneViewParent.isHidden = false
            
            if let  arSceneView = arSceneView {
                let newScene = SCNScene()
                sceneView.scene = newScene
                newScene.rootNode.name = "SceneView World Origin   🌎"
                
                // Create a new scene when we switch back to AR mode
                // And move our nodes into the new scene
                let arSceneRootNode = arSceneView.scene.rootNode
                for child in arSceneRootNode.childNodes {
                    if let _ = child.camera {
                        if child.name == nil {
                            // Add a camera model to the AR Camera
                            child.addChildNode(Model.camera.createNode())
                            child.name = "AR Camera"

                            // Create Add gameModeCameraNode
                            addCamera(to: sceneView)

                            // Setup gameModeCameraNode
                            gameModeCameraNode.position = SCNVector3(x: -0.15, y: 0.31, z: 0.54) * 2
                            gameModeCameraNode.look(at: SCNVector3Make(0, 0, 0))

                        } else if child.name == "AR Camera" {
                            addCamera(to: sceneView)
                        }
                    }
                    newScene.rootNode.addChildNode(child) // Suprisingly, feature points still work
                }
                
                rootNode = newScene.rootNode
            }
        }
    }
    
    private static func gameModeCameraMake() -> SCNNode {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.camera?.zNear = 0.0001
        return node
    }
    
    private func addCamera(to sceneView: SCNView) {
        gameModeCameraNode.name = "Game Mode Camera"
        sceneView.scene!.rootNode.addChildNode(gameModeCameraNode)
        sceneView.pointOfView = gameModeCameraNode
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

    func selectedForHierachyPanel() -> SCNNode? {
        return selectedNode
    }
}
