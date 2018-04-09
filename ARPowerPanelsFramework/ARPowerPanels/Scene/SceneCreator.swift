//
//  SceneCreator.swift
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

public class SceneCreator {
    
    public static let shared = SceneCreator()
    
    private var nodeMetaDatas = [SCNNode: NodeMetaData]()
    
    // TODO remove the to parentNode
    // Only use this to set meta data
    public func addNode(_ node: SCNNode, to parentNode: SCNNode) {
        parentNode.addChildNode(node)
        
        nodeMetaDatas[node] = NodeMetaData(displayInHierachy: true)
        node.enumerateChildNodes { (child, _) in
            nodeMetaDatas[child] = NodeMetaData(displayInHierachy: false)
        }
        
        nodeMetaDatas[parentNode] = NodeMetaData(displayInHierachy: true)
    }
    
    public func removeNode(_ node: SCNNode?) {
        guard let node = node else { return }
        node.removeFromParentNode()
        node.enumerateHierarchy { (node, _) in
            nodeMetaDatas[node] = nil
        }
    }
    
    public func displayInHierachy(node: SCNNode) -> Bool {
        return nodeMetaDatas[node]?.displayInHierachy ?? true
    }
}
