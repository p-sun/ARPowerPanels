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
    
    func iterateThough(rootNode: SCNNode) {
        hierachyStates = []
        self.rootNode = rootNode
        iterateThough(node: rootNode, level: 0)
        delegate?.hierachyIterator(didChange: hierachyStates)
    }
    
    private func iterateThough(node: SCNNode, level: Int) {
        
        var spaces = ""
        for _ in 0 ... level {
            spaces += "-"
        }
        
        let name: String
        if level == 0 {
            name = "Root Node"
        } else {
            name = node.name ?? "untitled"
        }
        
        let expandableState: ExpandableState
        if node.childNodes.count == 0 {
            expandableState = .isNotExpandable
        } else { // .isExpandable
            expandableState = expandStateForNode[node] ?? .isExpanded
        }
                
        let state = HierachyState(node: node,
                                  level: level,
                                  expandableState: expandableState,
                                  text: name,
                                  font: UIFont.gameModelLabel,
                                  color: .white) { [weak self] in
                                    
                                    guard let strongSelf = self, let rootNode = strongSelf.rootNode else { return }
                                    
                                    let currentState = strongSelf.expandStateForNode[node] ?? ExpandableState.isExpanded
                                    switch currentState {
                                    case .isNotExpanded:
                                        strongSelf.expandStateForNode[node] = .isExpanded
                                        strongSelf.iterateThough(rootNode: rootNode)
                                    case .isExpanded:
                                        strongSelf.expandStateForNode[node] = .isNotExpanded
                                        strongSelf.iterateThough(rootNode: rootNode)
                                    case .isNotExpandable:
                                        return
                                    }
        }
        hierachyStates.append(state)
        
        if expandStateForNode[node] ?? ExpandableState.isExpanded == .isExpanded {
            for child in node.childNodes {
                iterateThough(node: child, level: level + 1)
            }
        }
    }
}
