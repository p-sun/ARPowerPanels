//
//  HierachyPanel.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-28.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import SceneKit
import UIKit

protocol HierachyPanelDataSource: class {
    func selectedForHierachyPanel() -> SCNNode?
}

protocol HierachyPanelDelegate: class {
    func hierachyPanel(didSelectNode node: SCNNode)
}

class HierachyPanel: UIView {
    
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let functionalTableData = FunctionalTableData()
    
    private let iterator = HierachyIterator()

    weak var delegate: HierachyPanelDelegate?
    weak var dataSource: HierachyPanelDataSource? {
        didSet {
            renderHierachy()
        }
    }
    
    private weak var rootNode: SCNNode?
    
    init() {
        super.init(frame: CGRect.zero)
        iterator.delegate = self
        
        let addRemoveButtonStack = UIStackView()
        addRemoveButtonStack.backgroundColor = UIColor.green
        addRemoveButtonStack.axis = .horizontal
        addSubview(addRemoveButtonStack)
        addRemoveButtonStack.distribution = .fillEqually
        addRemoveButtonStack.spacing = 10
        addRemoveButtonStack.constrainLeft(to: self)
        addRemoveButtonStack.constrainBottom(to: self)
        addRemoveButtonStack.constrainHeight(44)
        addRemoveButtonStack.constrainEdgesHorizontally(to: self)
        
        let addModelButton = RoundedButton()
        addModelButton.isSelected = true
        addModelButton.addTarget(self, action: #selector(addModelPressed), for: .touchUpInside)
        addModelButton.setTitle("+ Model")
        addRemoveButtonStack.addArrangedSubview(addModelButton)
        
        let addShapeButton = RoundedButton()
        addShapeButton.isSelected = true
        addShapeButton.addTarget(self, action: #selector(addShapePressed), for: .touchUpInside)
        addShapeButton.setTitle("+ Shape")
        addRemoveButtonStack.addArrangedSubview(addShapeButton)
        
        let removeModelButton = RoundedButton()
        removeModelButton.isSelected = true
        removeModelButton.addTarget(self, action: #selector(removeModelPressed), for: .touchUpInside)
        removeModelButton.setTitle("Delete")
        addRemoveButtonStack.addArrangedSubview(removeModelButton)
        
        tableView.addCornerRadius()
        tableView.backgroundColor = .clear
        addSubview(tableView)
        tableView.constrainTop(to: self)
        tableView.constrainBottomToTop(of: addRemoveButtonStack, priority: .defaultHigh)
        tableView.constrainLeft(to: self)
        tableView.constrainRight(to: self, priority: .defaultHigh)
        functionalTableData.tableView = tableView
        
        renderHierachy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderHierachy(rootNode: SCNNode) {
        self.rootNode = rootNode
        iterator.createHierachyStates(rootNode: rootNode)
    }
    
    private func renderHierachy() {
        guard let rootNode = rootNode else { return }
        iterator.createHierachyStates(rootNode: rootNode)
    }
    
    @objc private func addModelPressed(_ button: UIButton) {
        let modelPicker = ModelCollectionView(frame: bounds, nodeMakers: Model.allTypes)
        modelPicker.delegate = self
        modelPicker.backgroundColor = #colorLiteral(red: 0.01086046056, green: 0.06186843822, blue: 0.400000006, alpha: 1)
        modelPicker.addCornerRadius()
        addSubview(modelPicker)
        modelPicker.constrainEdges(to: self)
        button.isSelected = true
    }
    
    @objc private func addShapePressed(_ button: UIButton) {
        let shapePicker = ModelCollectionView(frame: bounds, nodeMakers: Shapes.allTypes)
        shapePicker.delegate = self
        shapePicker.backgroundColor = #colorLiteral(red: 0.3594371684, green: 0.06657016599, blue: 0.2541848027, alpha: 1)
        shapePicker.addCornerRadius()
        addSubview(shapePicker)
        shapePicker.constrainEdges(to: self)
        button.isSelected = true
    }
    
    @objc private func removeModelPressed(_ button: UIButton) {
        let selectedNode = dataSource?.selectedForHierachyPanel()
        let parentNode = selectedNode?.parent
        SceneGraphManager.shared.removeNode(selectedNode)
        
        if let parentNode = parentNode {
            delegate?.hierachyPanel(didSelectNode: parentNode)
        } else if let rootNode = rootNode {
            delegate?.hierachyPanel(didSelectNode: rootNode)
        } else {
            renderHierachy()
        }
        
        button.isSelected = true
    }
}

// MARK: Private

extension HierachyPanel: ModelCollectionViewDelegate {
    func modelCollectionView(_ modelCollectionView: ModelCollectionView, didSelectModel nodeMaker: NodeCreatorType) {
        guard let selectedNode = dataSource?.selectedForHierachyPanel() else { return }
        if let newNode = nodeMaker.createNode() {
            SceneGraphManager.shared.addNode(newNode, to: selectedNode)
            delegate?.hierachyPanel(didSelectNode: newNode)
        } else {
            NSLog("PAIGE LOG: could not get model for node \(String(describing: nodeMaker.menuImage))")
        }
    }
}

extension HierachyPanel: HierachyIteratorDelegate {
    func hierachyIterator(didChange hierachyStates: [HierachyState]) {
        render(nodeHierachies: hierachyStates)
    }
    
    private func render(nodeHierachies: [HierachyState]) {
        guard bounds.width > 0 else {
            return
        }
        
        var cells = [CellConfigType]()
        let selectedNode = dataSource?.selectedForHierachyPanel()
        for hierachyState in nodeHierachies {
            let isNodeSelected = selectedNode == hierachyState.node

            let backgroundColor = isNodeSelected ? UIColor.uiControlColor.withAlphaComponent(0.6) : .clear
            let cell = HierachyCell(
                key: "node \(hierachyState.node.memoryAddress)",
                style: CellStyle(topSeparator: .full, bottomSeparator: .full, separatorColor: .white, backgroundColor: backgroundColor),
                actions: CellActions(selectionAction: { [weak self] _ in
                    self?.delegate?.hierachyPanel(didSelectNode: hierachyState.node)
                    return .deselected
                }),
                state: hierachyState)
            cells.append(cell)
        }
        
        let section = TableSection(key: "table section", rows: cells)
        functionalTableData.renderAndDiff([section])
    }
}
