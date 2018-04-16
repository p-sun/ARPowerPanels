//
//  Assets.swift
//  ARPowerPanels
//
//  Created by TSD040 on 2018-04-02.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit

//enum Asset {
//    enum Directory {
//        case imagesShapes
//        case imagesAdventure
//        case imagesMenu
//        case scnAssets
//
//        func directoryName() -> String? {
//            switch self {
//            case .imagesShapes: return "imagesShapes/"
//            case .imagesAdventure: return "imagesAdventure/"
//            case .imagesMenu: return "imagesMenu/"
//            case .scnAssets: return "art.scnassets/"
//            }
//        }
//    }

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
//}

// Frameworks can't use xcassets
// For iOS framework, images go into any folder (i.e Resources)
// For PlaygroundBook, images go in the 'Contents/PrivateResources` folder
enum ImageAssets {
    case closeWhite, checkmarkWhite
    case menuWolf, menuShip, menuLowPolyTree, menuFox
    case shapeBox, shapeCapsule, shapeCone, shapeCylinder, shapePlane, shapePyramid, shapeSphere, shapeTorus, shapeTube
    
    func image() -> UIImage? {
        switch self {
        case .closeWhite:
            return ImageAssets.imageForName("closeWhite", extensionName: "png")
        case .checkmarkWhite:
            return ImageAssets.imageForName("checkmarkWhite", extensionName: "png")
            
        case .menuWolf:
            return ImageAssets.imageForName("menuWolf", extensionName: "png")
        case .menuShip:
            return ImageAssets.imageForName("menuShip", extensionName: "png")
        case .menuLowPolyTree:
            return ImageAssets.imageForName("menuLowPolyTree", extensionName: "png")
        case .menuFox:
            return ImageAssets.imageForName("menuFox", extensionName: "jpeg")
            
        case .shapeBox:
            return ImageAssets.imageForName("shapeBox", extensionName: "png")
        case .shapeCapsule:
            return ImageAssets.imageForName("shapeCapsule", extensionName: "png")
        case .shapeCone:
            return ImageAssets.imageForName("shapeCone", extensionName: "png")
        case .shapeCylinder:
            return ImageAssets.imageForName("shapeCylinder", extensionName: "png")
        case .shapePlane:
            return ImageAssets.imageForName("shapePlane", extensionName: "png")
        case .shapePyramid:
            return ImageAssets.imageForName("shapePyramid", extensionName: "png")
        case .shapeSphere:
            return ImageAssets.imageForName("shapeSphere", extensionName: "png")
        case .shapeTorus:
            return ImageAssets.imageForName("shapeTorus", extensionName: "png")
        case .shapeTube:
            return ImageAssets.imageForName("shapeTube", extensionName: "png")
        }
    }
    
    static func imageForName(_ name: String, extensionName: String?) -> UIImage? {
        let bundle = Bundle(for: ModelCollectionView.self)
        if let url = bundle.path(forResource: name, ofType: extensionName) {
            return UIImage(contentsOfFile: url)
        }
        return nil
    }
}

