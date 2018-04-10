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
        SceneCreator.shared.addNode(node, to: parentNode)
    }
    
    func removeNode(_ node: SCNNode?) {
        SceneCreator.shared.removeNode(node)
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
        if let xyzAxis = Model.axis.createNode() {
            xyzAxis.name = "World Origin Axis"
            addNode(xyzAxis, to: scene.rootNode)
        }
        
        //: ## Add a fox at (0, 0, 0)
        if let foxNode = Model.fox.createNode() {
            foxNode.name = "Boss 🦊"
            addNode(foxNode, to: scene.rootNode)
        }
        
        //: ## Add another fox, and move it around
        if let anotherFox = Model.fox.createNode() {
            
            anotherFox.name = "Dizzy 🦊"
            anotherFox.position = SCNVector3Make(-0.03, 0, 0)
            anotherFox.scale = SCNVector3Make(0.8, 0.8, 0.8)
            anotherFox.eulerAngles = SCNVector3Make(0, 17, 45).degreesToRadians
            addNode(anotherFox, to: scene.rootNode)
            
            //: ## Animate the second fox
            anotherFox.runAction(
                SCNAction.repeatForever(
                    SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)))
        }
        
        let arViewController = ARKitViewController(
            scene: scene,
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
