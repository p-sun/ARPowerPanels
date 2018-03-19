//
//  ARSCNView+HitTest.swift
//  ARWorld
//
//  Created by TSD040 on 2018-02-25.
//  Copyright © 2018 sudo-world. All rights reserved.
//

import ARKit

extension ARSCNView {
    func sceneHitTest(at screenPos: CGPoint, within rootNode: SCNNode) -> SCNVector3? {
        let hits = hitTest(screenPos, options: [
            .boundingBoxOnly: true,
            .firstFoundOnly: true,
            .rootNode: rootNode,
            .ignoreChildNodes: true
            ])
        
        return hits.first?.worldCoordinates
    }
    
    func realWorldHit(at screenPos: CGPoint) -> (transformInWorld: SCNMatrix4?, planeAnchor: ARPlaneAnchor?, hitAPlane: Bool) {
        
        // -------------------------------------------------------------------------------
        // 1. Always do a hit test against exisiting plane anchors first.
        //    (If any such anchors exist & only within their extents.)
        
        
        
        let planeHitTestResults = hitTest(screenPos, types: [.existingPlaneUsingExtent]) // .existingPlane will assume a bigger plane (altho not infinite), but it created other problems we saw in hackathon, show us the problems, we will figure if we can do something about it
        if let result = planeHitTestResults.first {
            
            //            let planeHitTestPosition = SCNVector3.positionFromTransform(result.worldTransform)
            let planeAnchor = result.anchor
            
            // Return immediately - this is the best possible outcome.
            return (SCNMatrix4(result.worldTransform), planeAnchor as? ARPlaneAnchor, true)
        }
        
        // -------------------------------------------------------------------------------
        // 2. Collect more information about the environment by hit testing against
        //    the feature point cloud, but do not return the result yet.
        
        var featureHitTestTransform: SCNMatrix4?
        var highQualityFeatureHitTestResult = false
        
        let highQualityfeatureHitTestResults = hitTestWithFeatures(screenPos, coneOpeningAngleInDegrees: 18, minDistance: 0.2, maxDistance: 2.0)
        
        if !highQualityfeatureHitTestResults.isEmpty {
            let result = highQualityfeatureHitTestResults[0]
            
            let sketchyResult = SCNMatrix4MakeTranslation(result.position.x, result.position.y, result.position.z)
            
            featureHitTestTransform = sketchyResult
            highQualityFeatureHitTestResult = true
        }
        
        // -------------------------------------------------------------------------------
        // 4. If available, return the result of the hit test against high quality
        //    features if the hit tests against infinite planes were skipped or no
        //    infinite plane was hit.
        
        if highQualityFeatureHitTestResult {
            return (featureHitTestTransform, nil, false)
        }
        
        // _______________________________________________________________________________
        // 5. If there are no high quality feature points to use, then infer existing position
        // on the lowest existing plane assuming that is will be the floor.
        let extendedPlaneHitTestResults = hitTest(screenPos, types: [.existingPlane])
        let sortedResults = extendedPlaneHitTestResults.sorted { (a, b) -> Bool in
            return a.worldTransform.position.y <= b.worldTransform.position.y ? true : false
        }
        if let result = sortedResults.first {
            let planeAnchor = result.anchor
            
            return (SCNMatrix4(result.worldTransform), planeAnchor as? ARPlaneAnchor, true)
        }
        
        //        // -------------------------------------------------------------------------------
        //        // 6. As a last resort, perform a second, unfiltered hit test against features.
        //        //    If there are no features in the scene, the result returned here will be nil.
        //
        //        let unfilteredFeatureHitTestResults = sceneView.hitTestWithFeatures(screenPos)
        //        if !unfilteredFeatureHitTestResults.isEmpty {
        //            let result = unfilteredFeatureHitTestResults[0]
        //
        //            let sketchyResult = SCNMatrix4MakeTranslation(result.position.x, result.position.y, result.position.z)
        //
        //            return (sketchyResult, nil, false)
        //        }
        
        return (nil, nil, false)
    }
    
}
