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
 - Add a button to disable tapping on the object to select it (b/c that object may have other selection actions). Alternatively, allow selection of objects by tapping, and allow multiple actions simultaneously.

 Bugs
 - Fix re-creating the gameNodeCamera if the gameNodeCamera was deleted? -- recreate it from the POV of the scene?
 - Add ability to reposition the pivot -- make sure the axis updates
 - ARKit adds a node with a geometry that can't be deleted. Activating the yellow glow on it causes a flicker and may crash the app. Hackily removed from the Scene Graph for now.
   - http://loufranco.com/blog/debug-iphone-crash-exc_bad_access
 
 Cleanup
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
            let shouldNotGlow = selectedNode.childNodes.isEmpty && selectedNode.geometry == nil
            let shouldHighlightNode = !isRootNode && !shouldNotGlow
            
            if enableMetalGlow {
                oldValue?.setGlow(false)

                // PlaygroundBook doesn't work with Metal shaders
                // Don't glow things with no children or geometry
                // Don't glow ARSCNView.rootNode because doesn't work well with the debug feature points
                if shouldHighlightNode {
                    selectedNode.setGlow(true)
                }

            } else {
            
                if let oldValue = oldValue {
                    let oldBoxNode = oldValue.directChildNode(withName: NodeNames.boundingBox.rawValue)
                    oldBoxNode?.removeFromParentNode()
                }

                if shouldHighlightNode {
                    let currentBoxNode = selectedNode.directChildNode(withName: NodeNames.boundingBox.rawValue)
                    let hasBoundingBox = currentBoxNode != nil
                    if !hasBoundingBox {
                        TransformationPanel.addBoundingBox(for: selectedNode)
                    }
                }
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
    
    private var arCameraBackground: Any?

    private let enableMetalGlow: Bool
    
    private var rootNode: SCNNode {
        let toDoNode = SCNNode()
        toDoNode.name = "TODO. Take care of this case."
        
        if isARMode {
            return arSceneView?.scene.rootNode ?? toDoNode
        } else {
            return sceneView.scene?.rootNode ?? toDoNode
        }
    }
    
    public convenience init(scene: SCNScene,  panelTypes: [ARPowerPanelsType]) { //TODO
        self.init(isARKit: false, panelTypes: panelTypes, enableMetalGlow: true)
        sceneView.backgroundColor = #colorLiteral(red: 0.1654644267, green: 0.3628849843, blue: 0.5607843399, alpha: 1)

        sceneView.scene = scene

        // Set the selected node, and update all the panels to control this node
        selectedNode = scene.rootNode
    }
    
    public convenience init(arSceneView: ARSCNView, panelTypes: [ARPowerPanelsType], enableMetalGlow: Bool) {

        self.init(isARKit: true, panelTypes: panelTypes, enableMetalGlow: enableMetalGlow)
        self.arSceneView = arSceneView
        allowTapGestureToSelectNode(arView: arSceneView)
        
        // Select AR Mode (i.e. hide the GameMode)
        sceneViewParent.isHidden = true
        
        // Set the selected node, and update all the panels to control this node
        selectedNode = SCNNode()//arSceneView.scene.rootNode // TOdo
        
        sceneView.scene = arSceneView.scene
        sceneView.isPlaying = true
        
        
        let arPOV = arSceneView.pointOfView!
        arPOV.name = NodeNames.arModeCamera.rawValue

        let sceneCameraPov = sceneCameraMake()
        SceneGraphManager.shared.addNode(sceneCameraPov, to: rootNode)
        sceneView.pointOfView = sceneCameraPov
        
        let cameraModelNode = Model.camera.createNode()!
        SceneGraphManager.shared.addNode(cameraModelNode, to: arPOV)
    }
    
    private init(isARKit: Bool, panelTypes: [ARPowerPanelsType], enableMetalGlow: Bool) {
        hierachyPanel = HierachyPanel()
        self.enableMetalGlow = enableMetalGlow

        super.init(frame: CGRect.zero)
        
        // Init variables
        menuItems = panelTypes.map { menuForPanelType($0) }

        // Setup background
        constrainSceneView()
        //        if enableMetalGlow {
        //            sceneView.setupGlowTechnique()
        //        }
        
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
    
    // MARK: - Setup a Camera for the Scene View
    private func sceneCameraMake() -> SCNNode {
        let sceneViewCamera = SCNCamera()
        sceneViewCamera.name = "Scene Camera"
        sceneViewCamera.zFar = 10
        sceneViewCamera.zNear = 0.0001
        sceneViewCamera.usesOrthographicProjection = true
        
        // Create a node to hold the sceneViewCamera
        let sceneCameraPov = SCNNode()
        sceneCameraPov.camera = sceneViewCamera
        sceneCameraPov.name = NodeNames.gameModeCamera.rawValue
        sceneCameraPov.position = SCNVector3(x: -0.18, y: 0.02, z: 0.30)
        sceneCameraPov.look(at: SCNVector3Make(0, 0, 0))
        return sceneCameraPov
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
        if self.isARMode {
            hitTestResults = self.arSceneView?.hitTest(
                tapPoint,
                options: [.firstFoundOnly: true]) ?? []
        } else {
            hitTestResults = self.sceneView.hitTest(
                tapPoint,
                options: [.firstFoundOnly: true])
        }
        
        if let hitTestNode = hitTestResults.first?.node,
            let nodeInSceneGraph = SceneGraphManager.shared.findParentInHierachy(for: hitTestNode, in: self.rootNode),
            !(nodeInSceneGraph.name?.isEmpty ?? true) {
            // Checking name is a hack to avoid selecting the ARKit node with the yellow feature points
            self.selectedNode = nodeInSceneGraph
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
        addSubview(sceneViewParent)
        sceneViewParent.constrainEdges(to: self)
        
        sceneView.backgroundColor = #colorLiteral(red: 0, green: 0.7552545071, blue: 0, alpha: 1)
        sceneView.allowsCameraControl = true
        
//                sceneView.showsStatistics = true
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
        arGameSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.inputSliderHeader],
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
    
    @objc private func segmentSelected(_ segmentedControl: UISegmentedControl) {
        if arCameraBackground == nil,
            let cameraContents = arSceneView?.scene.background.contents {
            arCameraBackground = cameraContents
        }
        
        if isARMode {
            sceneViewParent.isHidden = true
            arSceneView?.scene.background.contents = arCameraBackground
            sceneView.isPlaying = false
        } else {
            sceneViewParent.isHidden = false
            sceneView.scene?.background.contents = #colorLiteral(red: 0.0003343143538, green: 0.03833642512, blue: 0.4235294163, alpha: 1)
            sceneView.isPlaying = true
        }
    }
    
    private func selectRootNodeIfNeeded() {
        if selectedNode?.parent == nil, selectedNode != rootNode {
            selectedNode = rootNode
        }
    }
    
    private func gameModeCameraMake() -> SCNNode {
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
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.updateSelectedNodeLabel()
            strongSelf.hierachyPanel.renderHierachy(rootNode: strongSelf.rootNode)
        }
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
