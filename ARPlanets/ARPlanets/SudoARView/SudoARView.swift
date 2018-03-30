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

class SudoARView: UIView {
    
    var selectedNode: SCNNode? {
        didSet {
            selectedNode?.categoryBitMask = 2
//            if let foxModel = anotherFoxModel.childNode(withName: "Max", recursively: true) {
//                foxModel.categoryBitMask = 2 // Set to 1 to remove the glow
//            }
        }
    }
    
    // MARK: Views for Menu Items
    private let purplePanel = PurpleView()
    private let greenPanel = GreenView()
    private let transformationPanel = TransformationPanel(controlTypes: TransformationType.minimum)
    private let hierachyPanel: HierachyPanel
    
    // MARK: The Menu Itself
    private var menuItems = [MenuItem]()
    private let menuStack = MenuStack(axis: .vertical)
    
    // MARK: Other Views
    private let scene: SCNScene
    private var panelPresentor: RightPanelsPresenter!
    private let sceneView = SCNView()
    
    let anotherFoxModel = Model.fox.createNode()
    
    init(scene: SCNScene) {
        self.scene = scene
        hierachyPanel = HierachyPanel(scene: scene)

        super.init(frame: CGRect.zero)
        
        self.scene.rootNode.addChildNode(anotherFoxModel)
        anotherFoxModel.position = SCNVector3Make(1, 1, 1)
        
        menuItems = [
            MenuItem(name: "PURPLE", panelItem: PanelItem(viewToPresent: purplePanel, heightPriority: .init(250), preferredHeight: 400, width: 400)),
            MenuItem(name: "GREEN", panelItem: PanelItem(viewToPresent: greenPanel, heightPriority: .init(300), preferredHeight: 600, width: 400)),
            MenuItem(name: "TRANSFORMATION", panelItem: PanelItem(viewToPresent: transformationPanel, heightPriority: .init(1000), preferredHeight: nil, width: 400)),
            MenuItem(name: "SCENE GRAPH", panelItem: PanelItem(viewToPresent: hierachyPanel, heightPriority: .init(400), preferredHeight: 500, width: 400)),
        ]
        
        setupSceneView()
        setupSceneGlowEffect()
        setupShowHideMenuButton()
        
        panelPresentor = RightPanelsPresenter(presentingView: self)
        panelPresentor.delegate = self
        
        setupARGameModeSegmentedControl()
        setupVerticalMenuStack()
        
        hierachyPanel.delegate = self
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
        //        sceneView.showsStatistics = true
        sceneView.scene = scene
        addSubview(sceneView)
        sceneView.constrainEdges(to: self)
    }

    private func setupSceneGlowEffect() {
        // Draw a glow around models with node.categoryBitMask == 2
        // No glow around models with node.categoryBitMask == 1
        if let path = Bundle.main.path(forResource: "NodeTechnique", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path)  {
                let dict2 = dict as! [String : AnyObject]
                let technique = SCNTechnique(dictionary:dict2)
                sceneView.technique = technique
            }
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
        let showHideMenuButton = RoundedButton()
        showHideMenuButton.delegate = self
        showHideMenuButton.isSelected = true
        showHideMenuButton.setTitle("☰")
        addSubview(showHideMenuButton)
        showHideMenuButton.constrainTop(to: self, offset: 110)
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
        menuStack.constrainTop(to: self, offset: 180)
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

extension SudoARView: RightPanelsPresenterDelegate {
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

extension SudoARView: HierachyPanelDelegate {
    func hierachyPanel(didSelectNode node: SCNNode) {
        selectedNode = node
    }
}
