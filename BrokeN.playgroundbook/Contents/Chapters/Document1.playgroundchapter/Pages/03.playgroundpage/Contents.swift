//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Set your character on a plane.
 
 Before you bring Byte & Friends into the world, you need to decide where you want to place them, just like in [Learn to Code 2](x-playgrounds://document/?contentIdentifier=com.apple.playgrounds.learntocode2).
 
 Using code, you’ll create a new character object, decide on a `Point` you want to place the character, and then place the character on each plane you discover. Use the *X* and *Z* values to place a character. As you change these values, the character will move backward, forward, right, and left on top of the plane.
 
 **Try this:**
 
 1. Create a new character object, like this: `let hopper = Character(name: CharacterName.hopper)`
 2. Create a new position, using a [`Point`](glossary://point), like this: `let newPosition = Point(x: 1, z: 2)`
 3. Call `plane.place(character:at:)` using the character and position you created, like this: `plane.place(character: hopper, at: newPosition)`
 */
//#-hidden-code
import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current
page.needsIndefiniteExecution = true
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy
typealias Character = Actor

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, playSound(_:), Sound, ., boing, electricity, hat, pop, snare, Point, Character, CharacterName, blu, hopper, expert, (x:z:), x:z:, (x:z:, x:z:), plane, place(character:at:), (name:, name:, (name:), name:))
//#-code-completion(identifier, show, var, let, ., =, (, ), ())
//#-code-completion(identifier, hide, page, proxy, Listener, listener, planes, placedObjectsCount, detectedPlane(plane:))

//#-end-hidden-code
func detectedPlane(plane: Plane) {
    //#-editable-code
    //#-copy-destination("02.playgroundpage", id1)
    playSound(.boing)
    //#-end-copy-destination
    // Create your character and Point objects here
    
    //#-end-editable-code
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
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                if placedObjectsCount == 0 {
                    page.assessmentStatus = assessmentPoint(planes: planes)
                }
            })
        case .objectPlacedOnPlane(let object, let plane, let position):
            if let index = planes.index(of: plane) {
                object.position = position
                planes[index].placedObjects.append(object)
                
                proxy?.send(
                    PlaygroundMessageToLiveView.announceObjectPlacement(objects: planes[index].placedObjects).playgroundValue
                )
            }

            page.assessmentStatus = assessmentPoint(planes: planes)
        default:
            break
        }
    }
    func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) { }
}

let listener = Listener()
proxy?.delegate = listener
//#-end-hidden-code
