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
    func rootNodeForHierachy() -> SCNNode
    func selectedForHierachyPanel() -> SCNNode?
    func hierachyPanel(shouldDisplayChildrenFor: SCNNode) -> Bool
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
    
    init() {
        super.init(frame: CGRect.zero)
        iterator.delegate = self
        iterator.dataSource = self
        
        let addRemoveButtonStack = UIStackView()
        addRemoveButtonStack.backgroundColor = UIColor.green
        addRemoveButtonStack.axis = .horizontal
        addSubview(addRemoveButtonStack)
        addRemoveButtonStack.distribution = .fillEqually
        addRemoveButtonStack.spacing = 10
        addRemoveButtonStack.constrainLeft(to: self)
        addRemoveButtonStack.constrainBottom(to: self)
        addRemoveButtonStack.constrainHeight(44)
        addRemoveButtonStack.constrainWidth(210)
        
        let addModelButton = RoundedButton()
        addModelButton.addTarget(self, action: #selector(addModelPressed), for: .touchUpInside)
        addModelButton.setTitle("+ Model")
        addRemoveButtonStack.addArrangedSubview(addModelButton)
        
        let addShapeButton = RoundedButton()
        addShapeButton.addTarget(self, action: #selector(addShapePressed), for: .touchUpInside)
        addShapeButton.setTitle("+ Shape")
        addRemoveButtonStack.addArrangedSubview(addShapeButton)
        
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
    
    func renderHierachy() {
        guard let rootNode = dataSource?.rootNodeForHierachy() else { return }
        iterator.createHierachyStates(rootNode: rootNode)
    }
    
    @objc private func addModelPressed(_ button: UIButton) {
        let modelPicker = ModelCollectionView(frame: bounds)
        modelPicker.backgroundColor = #colorLiteral(red: 0.01086046056, green: 0.06186843822, blue: 0.400000006, alpha: 1)
        modelPicker.addCornerRadius()
        addSubview(modelPicker)
        modelPicker.constrainEdges(to: self)
        button.isSelected = false
    }
    
    @objc private func addShapePressed(_ button: UIButton) {
        let shapePicker = ModelCollectionView(frame: bounds)
        shapePicker.backgroundColor = #colorLiteral(red: 0.3594371684, green: 0.06657016599, blue: 0.2541848027, alpha: 1)
        shapePicker.addCornerRadius()
        addSubview(shapePicker)
        shapePicker.constrainEdges(to: self)
        button.isSelected = false
    }
}

// MARK: Private

extension HierachyPanel: HierachyIteratorDataSource {
    func hierachyIteractor(shouldDisplayChildrenFor node: SCNNode) -> Bool {
        return dataSource?.hierachyPanel(shouldDisplayChildrenFor: node) ?? true
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
