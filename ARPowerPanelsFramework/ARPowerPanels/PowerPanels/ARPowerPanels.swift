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

public enum ARPowerPanelsType {
    case sceneGraph, info, easyMoves, allMoves, allEdits
    
    static public var allTypes: [ARPowerPanelsType] {
        return [.sceneGraph, .info, .easyMoves, .allMoves, .allEdits]
    }
}

public class ARPowerPanels: UIView {
    
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
    private let arGameSegmentedControl = UISegmentedControl(items: ["AR", "Game"])
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

    private var rootNode: SCNNode {
        let toDoNode = SCNNode()
        toDoNode.name = "TODO. Take care of this case."
        
        if isARMode {
            return arSceneView?.scene.rootNode ?? toDoNode
        } else {
            return sceneView.scene?.rootNode ?? toDoNode
        }
    }
    
    public convenience init(scene: SCNScene, panelTypes: [ARPowerPanelsType]) { //TODO
        self.init(isARKit: false, panelTypes: panelTypes)
        sceneView.backgroundColor = #colorLiteral(red: 0.1654644267, green: 0.3628849843, blue: 0.5607843399, alpha: 1) // TODO change color
        
        sceneView.scene = scene
        
        // Set the selected node, and update all the panels to control this node
        selectedNode = scene.rootNode
    }
    
    public convenience init(arSceneView: ARSCNView, panelTypes: [ARPowerPanelsType]) {
        self.init(isARKit: true, panelTypes: panelTypes)
        self.arSceneView = arSceneView
        if !isPlaygroundBook {
            arSceneView.setupGlowTechnique()
        }

        // Select AR Mode (i.e. hide the GameMode)
        sceneViewParent.isHidden = true
        
        // Set the selected node, and update all the panels to control this node
        selectedNode = SCNNode()//arSceneView.scene.rootNode // TOdo
    }
    
    private init(isARKit: Bool, panelTypes: [ARPowerPanelsType]) {
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

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func selectNode(_ node: SCNNode) {
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

        if let selectedNode = selectedNode {
            infoPanel.control(selectedNode) // TODO refactor all these Transformation panels
            easyMovePanel.control(selectedNode)
            advancedMovePanel.control(selectedNode)
            allEditsPanel.control(selectedNode)
        }
        hierachyPanel.renderHierachy(rootNode: rootNode)
    }
    
    private func constrainSceneView() {
        sceneViewParent.backgroundColor = #colorLiteral(red: 0.0003343143538, green: 0.03833642512, blue: 0.4235294163, alpha: 1)
        addSubview(sceneViewParent)
        sceneViewParent.constrainEdges(to: self)
        
        sceneView.backgroundColor = #colorLiteral(red: 0.0003343143538, green: 0.03833642512, blue: 0.4235294163, alpha: 1)
        sceneView.allowsCameraControl = true // allows the user to manipulate the camera
        if !isPlaygroundBook { // TODO set a glow technique varabe, or a isPlaygroundBook var as the powerpanel's init
            sceneView.setupGlowTechnique()
        }
        //        sceneView.showsStatistics = true
        sceneViewParent.addSubview(sceneView)
        sceneView.constrainEdges(to: sceneViewParent)
    }
    
    private func setupSelectedNodeLabel() {
        selectedNodeLabel.font = UIFont.gameModelLabel
        selectedNodeLabel.textColor = UIColor.uiControlColor
        addSubview(selectedNodeLabel)
        selectedNodeLabel.constrainTop(to: self, offset: 140)
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
    private func setupARGameModeSegmentedControl() {
        arGameSegmentedControl.selectedSegmentIndex = 0
        arGameSegmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.inputSliderHeader],
                                                for: .normal)
        self.addSubview(arGameSegmentedControl)
        arGameSegmentedControl.constrainTop(to: self, offset: 80)
        arGameSegmentedControl.constrainLeading(to: self, offset: 30)
        arGameSegmentedControl.constrainSize(CGSize(width: 200, height: 30))
        arGameSegmentedControl.tintColor = .uiControlColor
        arGameSegmentedControl.addTarget(self, action: #selector(segmentSelected), for: .valueChanged)
    }
    
    private var isARMode: Bool {
        return arGameSegmentedControl.selectedSegmentIndex == 0
    }
    
    @objc private func segmentSelected(_ segmentedControl: UISegmentedControl) { // TODO refactor
        
        if isARMode {
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

                for child in sceneView.scene!.rootNode.childNodes { // TODO take care of this force unwrap
                    let newChild = child
                    child.removeFromParentNode()

                    if child.name != "Game Mode Camera" {
                        newScene.rootNode.addChildNode(newChild)
                    }
                }
                arSceneView.scene = newScene

                if selectedNode?.parent == sceneView.scene?.rootNode {

                    selectedNode = newScene.rootNode
                }

                sceneView.scene = nil
                
                if selectedNode == sceneView.scene?.rootNode {
                    selectedNode = arSceneView.scene.rootNode
                }
                
                updatePanels()

            } else {
                NSLog("ERROR: Going into ARMode without an ARSCNScene")
            }

        // GAME MODE *********************

        } else {
            sceneViewParent.isHidden = false
            
            if let arSceneView = arSceneView {
                let newScene = SCNScene()
                sceneView.scene = newScene
                newScene.rootNode.name = "SceneView World Origin   🌎"
                
                // Create a new scene when we switch back to AR mode
                // And move our nodes into the new scene
                let arSceneRootNode = arSceneView.scene.rootNode
                for child in arSceneRootNode.childNodes {
                    NSLog("PAIGE ADDING CHILD \(child)")

                    if let _ = child.camera {
                        if child.name == nil {
                            // Add a camera model to the AR Camera
                            if let cameraNode = Model.camera.createNode() {
                                child.addChildNode(cameraNode)
                                child.name = "AR Camera"
                                NSLog("PAIGE ADDED AR CAMERA")
                            } else {
                                NSLog("PAIGE LOG, COULD NOT ADD CAMERA NODE")
                            }

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
                
                if selectedNode == arSceneView.scene.rootNode {
                    selectedNode = sceneView.scene?.rootNode
                }
                
                updatePanels()
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
        showHideMenuButton.constrainTopToBottom(of: selectedNodeLabel, offset: 60)
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
                hierachyPanel.renderHierachy(rootNode: rootNode)
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
        hierachyPanel.renderHierachy(rootNode: rootNode)
    }
}

extension ARPowerPanels: HierachyPanelDelegate {
    func hierachyPanel(didSelectNode node: SCNNode) {
        selectedNode = node
    }
}

extension ARPowerPanels: HierachyPanelDataSource {
    func selectedForHierachyPanel() -> SCNNode? {
        return selectedNode
    }
}
