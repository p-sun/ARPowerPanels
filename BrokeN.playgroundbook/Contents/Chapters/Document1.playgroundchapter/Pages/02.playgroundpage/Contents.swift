//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Play a sound when you detect a plane.
 
 The camera sees many different types of features as you move the iPad around, but today you’ll focus on horizontal, flat surfaces called [planes](glossary://plane).
 
 Move your iPad around. See how the grid lines move in and out of existence, grow and shrink, or blend together? As the camera looks around the room, it’s noticing new things, just like you do when you turn your head.
 
 * callout(Tip):
 The camera sometimes has trouble spotting planes in a room with shiny, reflective surfaces or low lighting. If you’re having trouble seeing planes, try pointing the iPad in a different direction.
 
 Each time the camera sees a plane, it triggers the `detectedPlane(plane:)` function, which lets you access the 'Plane' object it found. That function doesn’t do anything yet, but you’re going to change that!
 
 **Try this:**
 
 Inside the `detectedPlane(plane)` function body, add code to make a noise when you detect a new plane. Make sure you turn your sound on so you know your code is working!
 */
//#-hidden-code
import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current
page.needsIndefiniteExecution = true
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, playSound(_:), Sound, ., boing, electricity, hat, pop, snare)
//#-end-hidden-code 
func detectedPlane(plane: Plane) {
    //#-copy-source(id1)
    //#-editable-code Remember to call the playSound(_:) function here!
    
    //#-end-editable-code
    //#-end-copy-source
    
    //#-hidden-code
    // Assessment, called once we detect a plane
    page.assessmentStatus = assessmentPoint()
    //#-end-hidden-code
}

//#-hidden-code
// Handle messages from the live view.
class Listener: PlaygroundRemoteLiveViewProxyDelegate {
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy,
                             received message: PlaygroundValue) {
        guard let liveViewMessage = PlaygroundMessageFromLiveView(playgroundValue: message) else { return }
        switch liveViewMessage {
        case .planeFound(let plane):
            detectedPlane(plane: plane)
        default:
            break
        }
    }
    func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) { }
}

let listener = Listener()
proxy?.delegate = listener
//#-end-hidden-code
