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
    
    init(displayInHierachy: Bool) {
        self.displayInHierachy = displayInHierachy
    }
}

public class SceneGraphManager {
    
    public static let shared = SceneGraphManager()
    
    private var nodeMetaDatas = [SCNNode: NodeMetaData]()
    
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
//        node.enumerateChildNodes { (child, _) in
//            hideInSceneGraph(child)
//        }
    }
    
    public func showInSceneGraph(_ node: SCNNode) {
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
    
    public func displayInHierachy(node: SCNNode) -> Bool {
        return nodeMetaDatas[node]?.displayInHierachy ?? true
    }
}
