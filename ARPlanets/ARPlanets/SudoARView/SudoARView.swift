//
//  SudoARView.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-28.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

protocol HasSelectedNode {
    func selectedSCNNode() -> SCNNode?
}

protocol SudoARViewDataSource: class, HierachyPanelDataSource {
}

class SudoARView: UIView {
    
    var selectedNode: SCNNode? {
        didSet {
            guard let selectedNode = selectedNode else { return }

            oldValue?.setGlow(false)
            selectedNode.setGlow(true)

            updateSelectedNodeLabel()
            transformationPanel.control(selectedNode)
            hierachyPanel.renderHierachy()
        }
    }
    
    weak var dataSource: SudoARViewDataSource? {
        didSet {
            hierachyPanel.dataSource = dataSource
        }
    }
    
    // MARK: Right-hand panels
    private let purplePanel = PurpleView()
    private let greenPanel = GreenView()
    private let transformationPanel = TransformationPanel(controlTypes: TransformationType.all)
    private let hierachyPanel: HierachyPanel
    
    // MARK: Left hand views
    private let showHideMenuButton = RoundedButton()
    private let selectedNodeLabel = UILabel()
    private var menuItems = [MenuItem]()
    private let menuStack = MenuStack(axis: .vertical)
    
    // MARK: Background views
    private let scene: SCNScene
    private var panelPresentor: ARPanelsPresenter!
    private let sceneView = SCNView()
    
    init(scene: SCNScene) {
        self.scene = scene
        hierachyPanel = HierachyPanel()

        super.init(frame: CGRect.zero)
        
        // Init variables
        menuItems = [
            MenuItem(name: "PURPLE", panelItem: PanelItem(viewToPresent: purplePanel, heightPriority: .init(250), preferredHeight: 400, width: 400)),
            MenuItem(name: "GREEN", panelItem: PanelItem(viewToPresent: greenPanel, heightPriority: .init(300), preferredHeight: 600, width: 400)),
            MenuItem(name: "TRANSFORMATION", panelItem: PanelItem(viewToPresent: transformationPanel, heightPriority: .init(1000), preferredHeight: nil, width: 400)),
            MenuItem(name: "SCENE GRAPH", panelItem: PanelItem(viewToPresent: hierachyPanel, heightPriority: .init(400), preferredHeight: 500, width: 400)),
        ]

        // Setup background
        setupSceneView()

        panelPresentor = ARPanelsPresenter(presentingView: self)
        panelPresentor.delegate = self
        
        // Setup left-hand menu
        setupARGameModeSegmentedControl()
        setupSelectedNodeLabel()
        setupShowHideMenuButton()
        setupVerticalMenuStack()
 
        // Setup right-hand panels
        hierachyPanel.delegate = self
        transformationPanel.transformationDelegate = self

        // Set the selected node, and update all the panels to control this node
        selectedNode = scene.rootNode
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectNode(_ node: SCNNode) {
        self.selectedNode = node
    }
    
    private func setupSceneView() {
        sceneView.allowsCameraControl = true // allows the user to manipulate the camera
        sceneView.backgroundColor = #colorLiteral(red: 0.0003343143538, green: 0.03833642512, blue: 0.4235294163, alpha: 1)
        sceneView.setupGlowEffect()
        //        sceneView.showsStatistics = true
        sceneView.scene = scene
        addSubview(sceneView)
        sceneView.constrainEdges(to: self)
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

extension SudoARView {
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
        print("segmeted control \(segmentedControl.selectedSegmentIndex)")
    }
}

extension SudoARView: RoundedButtonDelegate {
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

extension SudoARView: MenuStackDelegate {
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

extension SudoARView: ARPanelsPresenterDelegate {
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

extension SudoARView: TransformationPanelDelegate {
    func transformationPanelDidChangeNodeName() {
        updateSelectedNodeLabel()
        hierachyPanel.renderHierachy()
    }
}

extension SudoARView: HierachyPanelDelegate {
    func hierachyPanel(didSelectNode node: SCNNode) {
        selectedNode = node
    }
}

extension SudoARView: HasSelectedNode {
    func selectedSCNNode() -> SCNNode? {
        return selectedNode
    }
}
