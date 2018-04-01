//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Have fun!
 
 You now have all the tools you need to create and play in your own awesome augmented world!
 
 You can create multiple characters, stack objects on top of each other using the `(x:y:z)` initializer for `Point`, add gems—even take photos using your camera, and use those photos as [textures](glossary://texture) in your new world.
 
 Remember to move the iPad around! Augmented reality is a lot more fun when you interact with your scene by looking at it from different perspectives. You’ll also get to experience that awesome interactivity you added!
 
 **Some things to try:**
 
 Add characters:
 
 * callout(Add a character to the plane):
     `let hopper = Character(name: CharacterName.hopper)`\
     `position = Point(x: 2, z: 2)`\
     `plane.place(character: hopper, at: position)`
 
 Add a gem or two:
 
 * callout(Add a gem above the plane):
     `let gem = Gem()`\
     `position = Point(x: 0, y: 3, z: 0)`\
     `plane.place(gem: gem, at: position)`
 
 Add some shapes:
 
 * callout(Add a shape to the plane and give it a color):
     `let sphere = Shape(type: .sphere)`\
     `sphere.color = 🔵`\
     `position = Point(x: 1, z: 1)`\
     `plane.place(shape: sphere, at: position)`

 * callout(Add a shape to the plane and put a photo on it):
     `let sphere2 = Shape(type: .sphere)`\
     `sphere2.color = 🔴`\
     `sphere2.image = 🏞`\
     `position = Point(x: -1, z: -1)`\
     `plane.place(shape: sphere2, at: position)`

 **Tips:**
 
 * Place characters, shapes and gems around the plane.
 * You can use your own photo to put onto one of the shapes.
*/
//#-hidden-code
import PlaygroundSupport
import UIKit
let page = PlaygroundPage.current
page.needsIndefiniteExecution = true
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy
typealias Character = Actor
var planeCount = 0

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, image)
//#-code-completion(identifier, show, playSound(_:), Sound, ., boing, electricity, hat, pop, snare, Point, Character, CharacterName, blu, hopper, expert, Shape, ShapeType, type:), (type:, type:, (type:), cube, pyramid, sphere, color, image, (x:z:), x:z:, (x:z:, x:z:), (x:y:z:), x:y:z:, (x:y:z:, x:y:z:), plane, place(character:at:), place(gem:at:), place(shape:at:), (name:, name:, (name:), name:), Gem)
//#-code-completion(identifier, show, if, for, var, let, ., =, (, ), ())
//#-code-completion(identifier, hide, page, proxy, Listener, listener, planes, placedObjectsCount, detectedPlane(plane:), planeCount)

//#-end-hidden-code
func detectedPlane(plane: Plane) {
    //#-copy-source(id2)
    if planeCount > 0 { return }
    var position = Point(x: 1, z: 1)
    //#-editable-code
    
    //#-end-editable-code
    planeCount += 1
    //#-end-copy-source
}
//#-hidden-code

var planes = [Plane]()
var placedObjectsCount: Int { return planes.map{ $0.placedObjects.count }.reduce(0, +) }

// Handle messages from the live view.
class Listener: PlaygroundRemoteLiveViewProxyDelegate {
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy,
                             received message: PlaygroundValue) {
        
        guard let liveViewMessage = PlaygroundMessageFromLiveView(playgroundValue: message) else { return }
        
        switch liveViewMessage {
            
        case .planeFound(let plane):
            
            planes.append(plane)
            detectedPlane(plane: plane)
            
        case .objectPlacedOnPlane(let object, let plane, let position):
            
            if let index = planes.index(of: plane) {
                object.position = position
                planes[index].placedObjects.append(object)
                
                proxy?.send(
                    PlaygroundMessageToLiveView.announceObjectPlacement(objects: planes[index].placedObjects).playgroundValue
                )
            }
            
        default:
            break
        }
    }
    func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) { }
}

let listener = Listener()
proxy?.delegate = listener


//#-end-hidden-code
