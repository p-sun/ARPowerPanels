//
//  ARPowerPanels.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-28.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

/*
 TODO:
 Features
 - Add planet models for earth, moon, sun, saturn.
 - Add rotateForever animations for x, y, z. Add animation panel.
 - Use the earth planet model with axis to be world origin -- deletable
 - Add the extra Adventure models & then port again onto PlaygroundBook

 Bugs
 - Fix re-creating the gameNodeCamera if the gameNodeCamera was deleted? -- recreate it from the POV of the scene?
 - Add ability to reposition the pivot -- make sure the axis updates
 - ARKit adds a node with a geometry that can't be deleted. Activating the yellow glow on it causes a flicker and may crash the app. Hackily removed from the Scene Graph for now.
   - http://loufranco.com/blog/debug-iphone-crash-exc_bad_access
 
 Cleanup
 - Make FTD Private
 - Other TODO tags
 - May need to convert all of TransformationPanels to be FTD, or place the stackView in a scrollView?
 Pro: can have long scrolling table, and can allow user to decide how tall each panel should be.
 Con: effort, performance, need to rewrite the height priority logic. Cells might not be reused often enough to warrant the effort.
 
 PlaygroundBook Strangeness
 - Figure out how to import .dae files into the playgroundbook.
 **/

import UIKit
import SceneKit
import ARKit

// Playground books require a different set of code to load image and model assets.
var isPlaygroundBook = true

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

            let isRootNode = selectedNode.name?.contains(NodeNames.worldOrigin.rawValue) == true
            
            if !isPlaygroundBook {
                oldValue?.setGlow(false)
                
                // Don't glow ARSCNView.rootNode because doesn't work well with the debug feature points
                if !isRootNode {
                    selectedNode.setGlow(true)
                }
            } else {
                
//                // Don't glow playground book because 
//                if let oldValue = oldValue {
//                    let oldBoxNode = oldValue.directChildNode(withName: NodeNames.boundingBox.rawValue)
//                    oldBoxNode?.removeFromParentNode()
//                }
//
//                if !isRootNode {
//                    let currentBoxNode = selectedNode.directChildNode(withName: NodeNames.boundingBox.rawValue)
//                    let hasBoundingBox = currentBoxNode != nil
//                    if !hasBoundingBox {
//                        TransformationPanel.addBoundingBox(for: selectedNode)
//                    }
//                }
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
    private let arGameSegmentedControl = UISegmentedControl(items: ["AR", "Scene"])
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
        sceneView.backgroundColor = #colorLiteral(red: 0.1654644267, green: 0.3628849843, blue: 0.5607843399, alpha: 1)
        
        sceneView.scene = scene
        
        // Set the selected node, and update all the panels to control this node
        selectedNode = scene.rootNode
    }
    
    public convenience init(arSceneView: ARSCNView, panelTypes: [ARPowerPanelsType]) {
        self.init(isARKit: true, panelTypes: panelTypes)
        self.arSceneView = arSceneView
        allowTapGestureToSelectNode(arView: arSceneView)
        
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
    
    // TODO - Pass Gesture to Underlying View
    private func allowTapGestureToSelectNode(arView: ARSCNView) {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        tapGesture.addTarget(self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: self)

        let hitTestResults: [SCNHitTestResult]
        if isARMode {
            hitTestResults = arSceneView?.hitTest(
                tapPoint,
                options: [.firstFoundOnly: true]) ?? []
        } else {
            hitTestResults = sceneView.hitTest(
                tapPoint,
                options: [.firstFoundOnly: true])
        }
        
        if let hitTestNode = hitTestResults.first?.node,
            let nodeInSceneGraph = SceneGraphManager.shared.findParentInHierachy(for: hitTestNode, in: rootNode) {
            selectedNode = nodeInSceneGraph
        }
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
                return MenuItem(name: "TRANSFORM", panelItem: PanelItem(viewToPresent: advancedMovePanel, heightPriority: .init(998), preferredHeight: nil, width: 400))
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
        // Set rounded corners to match the default segmented control corners
        arGameSegmentedControl.layer.cornerRadius = 6
        
        arGameSegmentedControl.backgroundColor = .panelBackgroundColor
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
            if let currentCameraNode = sceneView.pointOfView, currentCameraNode != gameModeCameraNode,
                let currentCamera = currentCameraNode.camera {
                gameModeCameraNode.transform = currentCameraNode.transform
                gameModeCameraNode.camera?.fieldOfView = currentCamera.fieldOfView
            }
            
            if let arSceneView = arSceneView {
                let newScene = SCNScene()
                newScene.rootNode.name = NodeNames.arWorldOrigin.rawValue

                for child in sceneView.scene!.rootNode.childNodes { // TODO take care of this force unwrap
                    let newChild = child
                    child.removeFromParentNode()

                    if child.name != NodeNames.gameModeCamera.rawValue {
                        newScene.rootNode.addChildNode(newChild)
                    }
                }
                arSceneView.scene = newScene

                if selectedNode?.parent == sceneView.scene?.rootNode {

                    selectedNode = newScene.rootNode
                }

                sceneView.scene = nil
                
                selectRootNodeIfNeeded()
                updatePanels()
            } else {
                NSLog("ERROR: Going into ARMode without a ARSCNView -- how's this possible")
            }

        } else {
            sceneViewParent.isHidden = false
            
            if let arSceneView = arSceneView {
                let newScene = SCNScene()
                sceneView.scene = newScene
                newScene.rootNode.name = NodeNames.sceneViewWorldOrigin.rawValue
                
                // Create a new scene when we switch back to AR mode
                // And move our nodes into the new scene
                let arSceneRootNode = arSceneView.scene.rootNode
                for child in arSceneRootNode.childNodes {

                    if let _ = child.camera {
                        if child.name == nil {
                            
                            // Add a camera model to the AR Camera
                            if let cameraNode = Model.camera.createNode() {
                                cameraNode.name = "Camera Model"
                                SceneGraphManager.shared.addNode(cameraNode, to: child)
                                child.name = NodeNames.arModeCamera.rawValue
                            }

                            // Add gameModeCameraNode
                            sceneView.scene!.rootNode.addChildNode(gameModeCameraNode)
                            sceneView.pointOfView = gameModeCameraNode
                            
                            // Setup gameModeCameraNode
                            gameModeCameraNode.position = SCNVector3(x: -0.15, y: 0.31, z: 0.54) * 2
                            gameModeCameraNode.look(at: SCNVector3Make(0, 0, 0))

                        } else if child.name?.contains(NodeNames.arModeCamera.rawValue) == true {
                            
                            // Add gameModeCameraNode
                            sceneView.scene!.rootNode.addChildNode(gameModeCameraNode)
                            sceneView.pointOfView = gameModeCameraNode
                        }
                    }
                    
                    // Suprisingly, feature points still show up in game mode
                    newScene.rootNode.addChildNode(child)
                }
                
                selectRootNodeIfNeeded()
                updatePanels()
            }
        }
    }
    
    private func selectRootNodeIfNeeded() {
        if selectedNode?.parent == nil, selectedNode != rootNode {
            selectedNode = rootNode
        }
    }
    
    private static func gameModeCameraMake() -> SCNNode {
        let node = SCNNode()
        node.name = NodeNames.gameModeCamera.rawValue
        node.camera = SCNCamera()
        node.camera?.zNear = 0.0001
        return node
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
    func transformationPanelDidEditNode() {
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

extension ARPowerPanels: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Only receive touches to select nodes if the bottomMost view is selected
        if touch.view == sceneView || touch.view == self {
            return true
        }
        return false
    }
}
