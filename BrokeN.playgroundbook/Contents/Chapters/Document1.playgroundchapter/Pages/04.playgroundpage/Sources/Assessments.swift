//
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import PlaygroundSupport
import UIKit

/*
 Solution
let character = Character(name: .hopper)

character.reactBehind = [
    Action.turnLeft
    Action.turnLeft
]

character.reactOnLeft = [
    Action.turnLeft
]

character.reactOnRight = [
    Action.turnRight
]

character.reactTooClose = [
    Action.jump
]
*/

private let successString = NSLocalizedString("Great job! You've mastered the basics of detecting planes, placing characters, and interaction. On the [next page](@next) you'll get to use everything you've learned so far, plus some fun extra stuff, to create your own amazing augmented world!", comment:"Success message for fourth page.")
private let solutionString = NSLocalizedString("This is only one possible solution—use your creativity to think of other possibilities! \n\n````let character = Character(name: .hopper)\n\ncharacter.reactBehind = [Action.turnLeft, Action.turnLeft]\n\ncharacter.reactOnLeft = [Action.turnLeft]\n\ncharacter.reactOnRight = [Action.turnRight]\n\ncharacter.reactTooClose = [Action.jump]\n````", comment:"Solution for fourth page.")
private let addActionHint = NSLocalizedString("Try adding an action to one of the other character reaction arrays.", comment:"Hint for adding an action on page 4")

public func assessmentPoint(character: Actor) -> PlaygroundPage.AssessmentStatus {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var hints = [String]()
    
    if character.reactOnLeft.isEmpty &&
        character.reactOnRight.isEmpty &&
        character.reactTooClose.isEmpty {
        hints.append(addActionHint)
    }
    
    if !hints.isEmpty {
        // Show hints
        return .fail(hints: hints, solution: solutionString)
    } else {
        return .pass(message: successString)
    }
}
