//
//  HierarchyIteractor.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-29.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import SceneKit

protocol HierachyIteratorDelegate: class {
    func hierachyIterator(didChange hierachyStates: [HierachyState])
}

class HierachyIterator {
    
    private var hierachyStates = [HierachyState]()
    private var expandStateForNode = [SCNNode: ExpandableState]() // Default is isExpanded
    
    private var rootNode: SCNNode?
    
    weak var delegate: HierachyIteratorDelegate?

    @discardableResult // TODO fix
    func createHierachyStates(rootNode: SCNNode) -> [HierachyState] {
        self.rootNode = rootNode

        hierachyStates = []
        createHierachyStates(node: rootNode, level: 0)
        
        delegate?.hierachyIterator(didChange: hierachyStates) // TODO Refactor: make this not a callback
        return hierachyStates
    }
    
    private func createHierachyStates(node: SCNNode, level: Int) {
        
        var spaces = ""
        for _ in 0 ... level {
            spaces += "-"
        }
        
        let visibleChildNodes = SceneGraphManager.shared.visibleChildren(for: node)
        
        let expandableState: ExpandableState
        if visibleChildNodes.count == 0 {
            expandableState = .isNotExpandable
        } else { // .isExpandable
            expandableState = expandState(for: node)
        }
                
        let state = HierachyState(node: node,
                                  level: level,
                                  expandableState: expandableState,
                                  text: node.displayName,
                                  font: UIFont.gameModelLabel,
                                  color: .white) { [weak self] in
                                    
                                    guard let strongSelf = self, let rootNode = strongSelf.rootNode else { return }
                                    
                                    let currentState = strongSelf.expandState(for: node)
                                    switch currentState {
                                    case .isNotExpanded:
                                        strongSelf.expandStateForNode[node] = .isExpanded
                                        strongSelf.createHierachyStates(rootNode: rootNode)
                                    case .isExpanded:
                                        strongSelf.expandStateForNode[node] = .isNotExpanded
                                        strongSelf.createHierachyStates(rootNode: rootNode)
                                    case .isNotExpandable:
                                        return
                                    }
        }
        hierachyStates.append(state)
        
        if expandState(for: node) == .isExpanded {
            for child in visibleChildNodes {
                createHierachyStates(node: child, level: level + 1)
            }
        }
    }
    
    private func expandState(for node: SCNNode) -> ExpandableState {
        return expandStateForNode[node] ?? .isExpanded
    }
}
