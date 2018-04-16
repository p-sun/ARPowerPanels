//
//  SceneGraphManager.swift
//  ARPowerPanelsDemo
//
//  Created by TSD040 on 2018-04-01.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import Foundation
import SceneKit

struct NodeMetaData {
    let displayInHierachy: Bool
    var isDisplayedInHierachy: Bool = false
    
    init(displayInHierachy: Bool) {
        self.displayInHierachy = displayInHierachy
    }
}

public class SceneGraphManager {
    
    public static let shared = SceneGraphManager()
    
    private var nodeMetaDatas = [SCNNode: NodeMetaData]()
    
    private let iterator = HierachyIterator() // TODO refactor

    private init() {}
    
    // TODO Refactor
    public func addNode(_ node: SCNNode, to parentNode: SCNNode) {
        parentNode.addChildNode(node)
        
        showInSceneGraph(parentNode)
        showInSceneGraph(node)
        hideChildrenInSceneGraph(of: node)
    }
    
    private func hideChildrenInSceneGraph(of node: SCNNode) {
        for child in node.childNodes {
            hideInSceneGraph(child)
        }
    }
    
    private func showInSceneGraph(_ node: SCNNode) {
        nodeMetaDatas[node] = NodeMetaData(displayInHierachy: true)
    }

    public func hideInSceneGraph(_ node: SCNNode) {
        nodeMetaDatas[node] = NodeMetaData(displayInHierachy: false)
    }
    
    public func removeNode(_ node: SCNNode?) {
        guard let node = node else { return }
        node.enumerateHierarchy { (node, _) in
            nodeMetaDatas[node] = nil
        }
        node.removeFromParentNode()
    }
    
    // Whether or not a node should be displayed in hierachy
    public func shouldDisplayInHierachy(node: SCNNode) -> Bool {
        return nodeMetaDatas[node]?.displayInHierachy ?? true
    }
    
    public func setIsDisplayedInHierachy(node: SCNNode, isDisplayed: Bool) {
        nodeMetaDatas[node]?.isDisplayedInHierachy = isDisplayed
    }
    
    public func isDisplayedInHierachy(node: SCNNode) -> Bool { // TODO some of these are private now
        return nodeMetaDatas[node]?.isDisplayedInHierachy ?? false
    }
    
    public func visibleChildren(for node: SCNNode) -> [SCNNode] {
        let visible = node.childNodes.filter { child in
            let shouldDisplayChild = shouldDisplayInHierachy(node: child)
            setIsDisplayedInHierachy(node: child, isDisplayed: shouldDisplayChild)
            return shouldDisplayChild
        }
        
        return visible
    }
    
    func findParentInHierachy(for child: SCNNode, in rootNode: SCNNode) -> SCNNode? {
        let states = iterator.createHierachyStates(rootNode: rootNode)
        
        let allNodesOnSceneGraph = states.map({ $0.node })
        return findParentInHierachy(for: child, allNodesOnSceneGraph: allNodesOnSceneGraph)
    }
    
    private func findParentInHierachy(for child: SCNNode, allNodesOnSceneGraph: [SCNNode]) -> SCNNode? {
        
        if allNodesOnSceneGraph.contains(child) {
            return child
        }
        
        guard let parent = child.parent else { return nil }
        return findParentInHierachy(for: parent, allNodesOnSceneGraph: allNodesOnSceneGraph)
    }
    
}
