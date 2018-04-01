//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Add interactivity to your scene.
 
 Well done! You’ve settled your character into the world.
 
 * callout(Tip):
 Move your iPad around. The digital objects you placed in the scene stay still, and you can experience them from different angles.
 
 Now it’s time to bring your augmented scene alive! You can use code, combined with the camera data and your physical position in space, to tell your iPad which direction *you* are facing relative to your character.
 
 Your character should turn to face you as the iPad moves around them, and jump in surprise if you get too close!
 
 The first example is coded for you, so you can follow its example to add the other actions, and note that the `movementDetected()` function will be automatically called as the iPad notices movement.
 
 **Try this:**
 
 1. Make your character always face you, even if you move around them.
 2. Make your character `jump()` if you get too close.
 */
//#-hidden-code
import PlaygroundSupport
let page = PlaygroundPage.current
page.needsIndefiniteExecution = true
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy
typealias Character = Actor
typealias Action = ActorAction
var planeCount = 0

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, CharacterName, blu, hopper, expert, .)
//#-end-hidden-code
let character = Character(name: /*#-editable-code*/<#T##Character Name##CharacterName#>/*#-end-editable-code*/)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, hide, page, proxy, Listener, listener, planes, placedObjectsCount, planeCount, CharacterName, blu, hopper, expert)
//#-code-completion(identifier, show, jump, turnRight, turnLeft, Action)
//#-code-completion(identifier, show, playSound(_:), Sound, boing, electricity, hat, pop, snare, Point, Character)
//#-code-completion(identifier, show, var, let, ., (, ), (),,)

character.reactBehind = [
    //#-editable-code
    //This is an example - you can change it and try your own actions!
    Action.jump
    //#-end-editable-code
]

character.reactOnLeft = [
    //#-editable-code
    
    //#-end-editable-code
]

character.reactOnRight = [
    //#-editable-code
    
    //#-end-editable-code
]

character.reactTooClose = [
    //#-editable-code
    
    //#-end-editable-code
]

func detectedPlane(plane: Plane) {
    if planeCount > 0 { return }
    var position = Point(x: 0, z: 0)
//#-editable-code
    playSound(.boing)
    plane.place(character: character, at: position)
//#-end-editable-code
    planeCount += 1
    
    //#-hidden-code
    // Assessment, called once we detect a plane
    page.assessmentStatus = assessmentPoint(character: character)
    //#-end-hidden-code
}
//#-hidden-code
var planes = [Plane]()
var placedObjectsCount: Int { return planes.map{ $0.placedObjects.count }.reduce(0, +) }

// Listens for movement and triggers detectedMovement call
class DetectionListener: PlaygroundRemoteLiveViewProxyDelegate {
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

let listener = DetectionListener()
proxy?.delegate = listener
//#-end-hidden-code
