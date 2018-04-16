//
//  AppDelegate.swift
//  ARPowerPanelsDemo
//
//  Created by TSD040 on 2018-04-01.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import ARPowerPanels
import SceneKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func addNode(_ node: SCNNode, to parentNode: SCNNode) {
        SceneGraphManager.shared.addNode(node, to: parentNode)
    }
    
    func removeNode(_ node: SCNNode?) {
        SceneGraphManager.shared.removeNode(node)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //: ## Create a scene
        let scene = SCNScene()
        
        //: ## Add a light to the scene
        let lightNode = SCNNode()
        lightNode.name = "Light node"
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        addNode(lightNode, to: scene.rootNode)
        
        //: ## Add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.name = "Ambient Light Node"
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        addNode(ambientLightNode, to: scene.rootNode)
        
        //: ## Add an axis at (0, 0, 0). this is the world origin.
        let xyzAxis = NodeCreator.createAxesNode(quiverLength: 0.15, quiverThickness: 1.0)
        xyzAxis.name = "World Origin Axis"
        addNode(xyzAxis, to: scene.rootNode)
        
        //: ## Add a fox at (0, 0, 0)
        let foxNode = Model.fox.createNode()!
        foxNode.name = "Boss 🦊"
        addNode(foxNode, to: scene.rootNode)

        //: ## Add another fox, re-position it, and animate it
        let anotherFox = Model.fox.createNode()!
        anotherFox.name = "Dizzy 🦊"
        anotherFox.position = SCNVector3Make(-0.12, 0.06, 0)
        anotherFox.scale = SCNVector3Make(0.8, 0.8, 0.8)
        anotherFox.eulerAngles = SCNVector3Make(0, 17, -13.8).degreesToRadians
        addNode(anotherFox, to: scene.rootNode)
        
        anotherFox.runAction(
            SCNAction.repeatForever(
                SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)))
        
        //: ## Add a yellow box to orbit the spinning fox
        let boxGeometry = SCNBox(width: 0.04, height: 0.04, length: 0.04, chamferRadius: 0)
        boxGeometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 1, green: 0.9390204065, blue: 0.134511675, alpha: 1)
        let yellowBox = SCNNode(geometry: boxGeometry)
        yellowBox.name = "Yellow Orbiting Box"
        yellowBox.position = SCNVector3Make(0.22, -0.17, 0)
        addNode(yellowBox, to: anotherFox)
        
        yellowBox.runAction(
            SCNAction.repeatForever(
                SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 3)))
        
        //: ## Add a pink sphere to orbit the spinning fox
        let sphereGeometry = SCNSphere(radius: 0.01)
        sphereGeometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        let pinkSphere = SCNNode(geometry: sphereGeometry)
        pinkSphere.name = "Pink Orbiting Sphere"
        pinkSphere.position = SCNVector3Make(0.1, 0, 0)
        addNode(pinkSphere, to: yellowBox)
        
        //: ## Draw an arrow between Root Node to the Yellow Box
        let arrow = NodeCreator.createArrowNode(fromNode: scene.rootNode, toNode: yellowBox)
        arrow.name = "Root Node to Yellow Box"
        addNode(arrow, to: yellowBox)

        //: ## Draw an arrow between Yellow Box and the Pink Sphere
        let arrow2 = NodeCreator.createArrowNode(fromNode: yellowBox, toNode: pinkSphere)
        arrow2.name = "Yellow Box to Pink Sphere"
        addNode(arrow2, to: pinkSphere)
        
        let arViewController = ARKitViewController(
            scene: scene,
            selectedNode: foxNode,
            panelTypes: [.sceneGraph, .info, .allMoves])
        window?.rootViewController = arViewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
