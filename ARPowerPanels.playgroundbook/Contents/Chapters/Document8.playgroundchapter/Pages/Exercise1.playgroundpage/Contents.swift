//: This is a line of comments
//: # HI comments

/*:
 # How to Use Markup to Format Playgrounds

 ### Setup
 * To view the formatted text and links, go to Editor -> Show Rendered Markup.
 * To make it easier to switch between Raw-Markup and Rendered-Markup, go to Xcode -> Preferences -> Key Bindings -> filter "Markup" -> Assign Option-R as the key binding.
 * \//: This is how to write a single line of markup.
 * \/\*: This is how to write multiples lines of markup. *\/
 ---
 ### Text Formatting
 
 Regular text
 
 *Italicized text*
 
 **Bolded text**
 
 Numbered List:
 1. Cat (Note only the first number in the list matters.)
 333. Dog
 5. Golden Retriever
 232. Llama
 
 ---
 ### Links
 [Apple Documentation on markups](https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode_markup_formatting_ref/MarkupFunctionality.html#//apple_ref/doc/uid/TP40016497-CH54-SW1)
 
 [Next Playground page](@next)
 
 [Previous Playground page](@previous)
 
 [Specific Playground page by name](How%20to%20use%20HackerRank%20helpers)
 ---
 ### Callouts
 
 - Note:
 "There is nothing either good or bad, but thinking makes it so."
 \
 \
 Hamlet in (*Hamlet, 2.2*) by William Shakespeare
 This is yellow.
 
 - Callout(Llama Spotting Tips):
 Pack warm clothes with your binoculars.
 This is cyan on XCode, Gray in Playgrounds.
 
 * Experiment:
 Change the third case statement to work only with consonants
 This is pink
 
 Block Code Samples are indented and sandwiched by empty lines:
 
    for character in "Aesop" {
        print(character)}
    }
 
 In-line code samples are in single quotes: `print("Pizza")`.
 */

//: [Next Page](@next)

//#-hidden-code
//#-end-hidden-code

//#-editable-code Tap to enter code

import UIKit
import SceneKit
import ARKit
import PlaygroundSupport

class ARKitViewController: UIViewController {
    
    private var powerPanels: ARPowerPanels!
    private var arSceneView = ARSCNView()
    var scene = SCNScene()
    
    let panelTypes: [ARPowerPanelsType] //= ARPowerPanelsType.allTypes
    
    init(panelTypes: [ARPowerPanelsType]) {
        self.panelTypes = panelTypes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(arSceneView)
        arSceneView.constrainEdges(to: view)
        
        arSceneView.delegate = self
        //        arSceneView.showsStatistics = true
        arSceneView.debugOptions  = [.showConstraints, ARSCNDebugOptions.showFeaturePoints]//, ARSCNDebugOptions.showWorldOrigin]
        
        scene = SceneCreator.shared.createFoxPlaneScene()
        arSceneView.scene = scene
        scene.rootNode.name = "AR World Origin   🌎"
        
        powerPanels = ARPowerPanels(arSceneView: arSceneView, panelTypes: panelTypes)
        powerPanels.selectNode(scene.rootNode)
        view.addSubview(powerPanels)
        powerPanels.constrainEdges(to: view)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        beginarSceneView()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arSceneView.session.pause()
    }
    
    private func beginarSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        arSceneView.session.run(configuration)
    }
}

extension ARKitViewController: ARSCNViewDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        print("didAdd \(node.position)")
        
        let planeNode = NodeCreator.bluePlane(anchor: planeAnchor)
        planeNode.name = "Blue Plane"
        
        // ARKit owns the node corresponding to the anchor, so make the plane a child node.
        node.addChildNode(planeNode)
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Update size of the geometry associated with Plane nodes
        if let plane = node.childNodes.first?.geometry as? SCNPlane {
            plane.updateSize(toMatch: planeAnchor)
        }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {//
        print("didRemove \(node.position)")
    }
}

extension ARKitViewController {
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    public func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    public func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    public func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

// Present the view controller in the Live View window
//let liveController = UINavigationController(rootViewController: ExampleViewController())
//liveController.preferredContentSize = CGSize(width: 320, height: 420)
PlaygroundPage.current.liveView = ARKitViewController(panelTypes: ARPowerPanelsType.allTypes)

//#-end-editable-code

