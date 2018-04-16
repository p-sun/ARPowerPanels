/*:
 # Welcome to ARPowerPanels!
 
 * Experiment:
 Today is a good day for experimentation.
 \
 \
 "Control is for Beginners. Iteration is truly the mother of invention."
 
 
 Hello, fellow traveller.
 
 Whereever you are in your journey of learning or developing, I want to be of use to you. For people still developing their 3D intuition, this can be a playground within a playground. Once you start developing, you can use this framework to help you view and debug your scenes live, without having to pause your app.
 
 *"How far is 30 units?"*
 
 *"What does a quaternion look like?"*
 
 *"I dropped an model into my AR app -- but where did it go?"* <--- I feel you. This happens a lot to me.
 
 ARPowerPanels will help you answer that.
 
 Here are a few things to try.
 
 - Open the `Info` panel on the lefthand side. You can scrub your finger up and down to change the numbers, or you can tap into a text field to manually type any number. (The keyboard has a button to make the number negative, and another button to make it zero.)
 
 - Open the `Scene Graph`. This will show you the current hierachy of nodes in the scene. The emojis tell you whether there are any light, geometry, or camera attached to that node. You can tap the triangle to the left of a parent node to hide or show its children.
 
 - Tap on any row in the `Scene Graph` to select it. Open the   `Transform` panel. You can now view, rotate, scale, translate any node. Try to find the camera node that represents your iPad!
 
 - On the top left, tap "Scene". That's what your scene looks like from another point of view! Move your iPad around to see how feature points near where you are pointing your camera. That camera object represents your device! Tap the camera in the scene graph to move your POV around numerically. Drag your fingers across to rotate, pinch, or pan the camera.
 
 - See the spinning fox named Paige? See if you can guess how the rotational numbers will change in  `Info`, and then tap the `Dizzy` fox on the Scene Graph, and tap `Info` to view the animation live.
 
 - There can be up to two panels on the right side. Tap an menu item will show or dismiss it. Do you want the `Scene Graph` on top, and `Info` on the bottom? Dismiss all your panels, and then show them by tapping `Scene Graph` first, then `Info`
 
 - The `Info` tab lets you change the name of any node, and it also gives you the size of the smallest box that can contain that node and all its children. You can hide any node by changing the opacity to 0.
 
 - On the `Scene Graph` there are 3D models that you can place into your scene! The life sized wolf is my favourite -- I can stare at it all day. Selecting a model will place that model as a child of your selected node with no position or rotational values. If nothing happened, check that you have a node selected.
 
 - On the `Scene Graph` panel, you can also drop in some Geometric shapes. Try to create a rocket with the panels, and write down the numbers, and then recreate it in code~
 
 - The fox nodes has a lot of child nodes! If you want to how many pieces make up a tiny fox, simply replace
 `addNode(foxNode, to: scene.rootNode)`
 with
 `scene.rootNode.addChild(foxNode)`
 
 - Want to play with this on a phone, or use the whole thing, or bits and pieces on your app?
 Come grab the Universal iOS app, and [available on my Github](https://github.com/p-sun/ARPowerPanels).
 
 - After you're done experimenting around, feel free to take the project and drop it into any ARKit app to help you debug and understand it in real time. The `ARPowerPanel` class is just a view that takes an ARSCNView as a parameter -- it's easy to use.
 
 - Of course, try to create your own world here!
 
 
 -- Paige Sun
 
 - Note:
 GitHub [@p-sun](https://github.com/p-sun)
 Email [paige.sun.dev@gmail.com](paige.sun.dev@gmail.com)
 LinkedIn [https://www.linkedin.com/in/paigesun/](https://www.linkedin.com/in/paigesun/)
 Toronto, ON, Canada
 */

// ## Let's get started! 🚀

//#-hidden-code
import UIKit
import SceneKit
import ARKit
import PlaygroundSupport

func addNode(_ node: SCNNode, to parentNode: SCNNode) {
    SceneGraphManager.shared.addNode(node, to: parentNode)
}

func removeNode(_ node: SCNNode?) {
    SceneGraphManager.shared.removeNode(node)
}
//#-end-hidden-code

//#-editable-code Tap to enter code
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

//: ## Your turn! 😁









//#-end-editable-code

//#-hidden-code
let arViewController = ARKitViewController(
    scene: scene,
    selectedNode: foxNode,
    panelTypes: [.sceneGraph, .info, .allMoves])
PlaygroundPage.current.liveView = arViewController
//#-end-hidden-code
