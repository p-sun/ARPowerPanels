//
//  NodeCreator.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

public struct NodeCreator {
    
    public static func createArrowNode(fromNode: SCNNode, toNode: SCNNode) -> SCNNode {
        func arrowShape() -> SCNNode {
            let coneGeometry = SCNCone(topRadius: 0, bottomRadius: 0.02, height: 0.04)
            coneGeometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.8792779051, green: 0.9352593591, blue: 0.8162432972, alpha: 1)
            let arrowShape = SCNNode(geometry: coneGeometry)
            arrowShape.name = "Arrow Shape"
            arrowShape.eulerAngles = SCNVector3Make(Float(-90.0).degreesToRadians, 0, 0)
            return arrowShape
        }

        let boxGeometry = SCNBox(width: 0.004, height: 0.004, length: 0.5, chamferRadius: 0.02)
        boxGeometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.8792779051, green: 0.9352593591, blue: 0.8162432972, alpha: 1)

        func boxShape() -> SCNNode {
            let node = SCNNode()
            node.name = "BoxShape"
            node.geometry = boxGeometry
            return node
        }
        
        // Add Child Nodes
        let arrow = SCNNode()
        arrow.name = "Arrow"
        arrow.addChildNode(arrowShape())
        arrow.addChildNode(boxShape())
        
        // Add Constraints
        let lookAtConstraint = SCNLookAtConstraint(target: toNode)

        let transformConstraint = SCNTransformConstraint(inWorldSpace: true) { (node, transform) -> SCNMatrix4 in
            
            let transformNode = SCNNode()
            transformNode.transform = transform

            let deltaPosition = toNode.presentation.worldPosition - fromNode.presentation.worldPosition
            let middlePosition = fromNode.presentation.worldPosition + deltaPosition / 2
            transformNode.position = middlePosition

            boxGeometry.length = CGFloat(deltaPosition.length)
            
            return transformNode.transform
        }
        
        arrow.constraints = [lookAtConstraint, transformConstraint]
        
        return arrow
    }

    public static func createAxesNode(quiverLength: CGFloat, quiverThickness: CGFloat) -> SCNNode {
        let quiverThickness = (quiverLength / 50.0) * quiverThickness
        let chamferRadius = quiverThickness / 2.0
        
        let xQuiverBox = SCNBox(width: quiverLength, height: quiverThickness, length: quiverThickness, chamferRadius: chamferRadius)
        xQuiverBox.materials = [SCNMaterial.material(withDiffuse: UIColor.xAxisColor, respondsToLighting: false)]
        let xQuiverNode = SCNNode(geometry: xQuiverBox)
        xQuiverNode.position = SCNVector3Make(Float(quiverLength / 2.0), 0.0, 0.0)
        
        let yQuiverBox = SCNBox(width: quiverThickness, height: quiverLength, length: quiverThickness, chamferRadius: chamferRadius)
        yQuiverBox.materials = [SCNMaterial.material(withDiffuse: UIColor.yAxisColor, respondsToLighting: false)]
        let yQuiverNode = SCNNode(geometry: yQuiverBox)
        yQuiverNode.position = SCNVector3Make(0.0, Float(quiverLength / 2.0), 0.0)
        
        let zQuiverBox = SCNBox(width: quiverThickness, height: quiverThickness, length: quiverLength, chamferRadius: chamferRadius)
        zQuiverBox.materials = [SCNMaterial.material(withDiffuse: UIColor.zAxisColor, respondsToLighting: false)]
        let zQuiverNode = SCNNode(geometry: zQuiverBox)
        zQuiverNode.position = SCNVector3Make(0.0, 0.0, Float(quiverLength / 2.0))
        
        let quiverNode = SCNNode()
        quiverNode.addChildNode(xQuiverNode)
        quiverNode.addChildNode(yQuiverNode)
        quiverNode.addChildNode(zQuiverNode)
        quiverNode.name = "Axes"
        return quiverNode
    }
    
    static func axesBox() -> SCNNode {
        let box = SCNBox(width: 0.3, height: 0.01, length: 0.01, chamferRadius: 0.01)
        box.materials = [SCNMaterial.material(withDiffuse: UIColor.red, respondsToLighting: false)]
        return SCNNode(geometry: box)
    }
    
    static func blueBox() -> SCNNode {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor.blue
        
        let node = SCNNode()
        node.geometry = box
        return node
    }
    
    static func greenBox() -> SCNNode {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor.green
        
        let node = SCNNode()
        node.geometry = box
        return node
    }
    
    public static func bluePlane(anchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        plane.firstMaterial?.diffuse.contents = #colorLiteral(red: 0, green: 0.7457480216, blue: 1, alpha: 0.3189944402)
        
        let planeNode = SCNNode()
        planeNode.geometry = plane
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        // SCNPlanes are vertically oriented in their local coordinate space.
        // Rotate it to match the horizontal orientation of the ARPlaneAnchor.
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        // To set an image onto a plane instead
        //        let grassMaterial = SCNMaterial()
        //        grassMaterial.diffuse.contents = UIImage(named: "grass")
        //        grassMaterial.isDoubleSided = true
        //        plane.firstMaterial = grassMaterial
        
        
        return planeNode
    }
    
    static func greenPlane(anchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        plane.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.0499236755, green: 0.9352593591, blue: 0.0003146826744, alpha: 0.6324111729)
        
        let planeNode = SCNNode()
        planeNode.geometry = plane
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        // SCNPlanes are vertically oriented in their local coordinate space.
        // Rotate it to match the horizontal orientation of the ARPlaneAnchor.
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        planeNode.addChildNode(NodeCreator.blueBox())
        
        return planeNode
    }
    
}

public extension SCNPlane {
    public func updateSize(toMatch anchor: ARPlaneAnchor) {
        self.width = CGFloat(anchor.extent.x)
        self.height = CGFloat(anchor.extent.z)
    }
}
