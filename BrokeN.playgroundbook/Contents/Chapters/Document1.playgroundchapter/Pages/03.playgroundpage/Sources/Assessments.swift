//
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import PlaygroundSupport
import UIKit

/*
 Solution
func detectedPlane(plane: Plane) {
    playSound(Sound.boing)
    let blu = Character(name: CharacterName.blu)
    let position = Point(x: 0, z: 0)
    plane.place(character: blu at: position)
}
*/


private let successString = NSLocalizedString("Fantastic job! You’ve successfully created an augmented reality scene! Notice that if you move your iPad around to discover more planes, characters appear on all of them. That happens because you’re adding a new character every time a new plane is detected.  [Next Page](@next)", comment:"Success message for third page.")
private let solutionString = NSLocalizedString("```\nfunc detectedPlane(plane: Plane) {\n    playSound(Sound.boing)\n    let blu = Character(name: CharacterName.blu)\n    let position = Point(x: 0, z: 0)\n    plane.place(character: blu at: position)\n}\n```", comment:"Solution for third page.")
private let createCharacterHint = NSLocalizedString("You need to create a new character object using one of the available initializers; otherwise, you’ll have nothing to put on the plane.", comment:"Hint for creating new character object method.")
private let callPlaceFunctionHint = NSLocalizedString("It looks like you forgot to call the 'plane.place(character:at:)' function. If you don’t have that, nothing will appear on the planes the camera sees.", comment:"Hint for forgetting to call the placeCharacter function.")

public func assessmentPoint(planes: [Plane]) -> PlaygroundPage.AssessmentStatus {
    
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var hints = [String]()
    
    let placedObjectCount = planes.map{ $0.placedObjects.count }.reduce(0, +)
    
    if placedObjectCount >= 1 && planes.count >= 1 {
        let format = NSLocalizedString("sd:chapter1.page3.successMessage", comment: "Success message {number of planes found} {number of characters placed}")
        let successMessage = String.localizedStringWithFormat(format, planes.count, placedObjectCount)
        return .pass(message: successMessage)
    } else {
        let format = NSLocalizedString("sd:chapter1.page3.hintMessage", comment: "Hint message when didn't place any characters on the planes {number of planes found} ")
        let hintString = String.localizedStringWithFormat(format, planes.count)
        hints = [hintString]
        return .fail(hints: hints, solution: solutionString)
    }
}
