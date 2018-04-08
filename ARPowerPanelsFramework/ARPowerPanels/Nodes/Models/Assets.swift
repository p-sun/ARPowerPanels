//
//  Assets.swift
//  ARPowerPanels
//
//  Created by TSD040 on 2018-04-02.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import Foundation
enum Asset {
    enum Directory {
        case imagesShapes
        case imagesAdventure
        case imagesMenu
        case scnAssets

        func directoryName() -> String? {
            switch self {
            case .imagesShapes: return "imagesShapes/"
            case .imagesAdventure: return "imagesAdventure/"
            case .imagesMenu: return "imagesMenu/"
            case .scnAssets: return "art.scnassets/"
            }
        }
    }

//    static func node(named name: String, in directory: Directory, fileExtension: String = "dae") -> SCNNode? {
//        let path = directory.path + name
//        guard let url = Bundle.main.url(forResource: path, withExtension: fileExtension) else {
//            return nil
//        }
//
//        do {
//            let scene: SCNScene
//            scene = try SCNScene(url: url, options: [:])
//            return scene.rootNode.childNodes[0]
//        }
//        catch {
//            log(message: "Failed to find node at: '\(directory.path)\(name).\(fileExtension)'.")
//            return nil
//        }
//    }

//    static func scene(named name: String, in directory: Directory) -> SCNScene {
//        let dirPath = directory.path
//        guard let scene = SCNScene(named: name, inDirectory: dirPath, options: [:]) else {
//            fatalError("Failed to load scene: \(name).")
//        }
//        return scene
//    }
}
