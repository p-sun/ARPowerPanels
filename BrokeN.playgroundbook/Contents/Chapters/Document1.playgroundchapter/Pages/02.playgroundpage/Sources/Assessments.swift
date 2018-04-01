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
}

*/

private let successString = NSLocalizedString("Great! Did you try moving your iPad around to detect multiple planes? You should hear a sound every time the camera detects a new one. On the [next page](@next), you’ll use the plane as a \"floor\" for your character to stand on!", comment:"Success message for second page.")
private let solutionString = NSLocalizedString("```\nfunc detectedPlane(plane: Plane) {\n    playSound(Sound.boing)\n}\n```", comment:"Solution for plane detection page.")
private let planeDetectionHint = NSLocalizedString("Call the `playSound(_:)` function inside the body of the `detectedPlane(plane:)` function. The `playSound(_:)` function will be called every time the camera detects a new plane.", comment:"Hint for plane detection method.")

public func assessmentPoint() -> PlaygroundPage.AssessmentStatus {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var hints = [String]()
    
    if checker.functionCallCount(forName: "playSound") == 0 {
        hints.append(planeDetectionHint)
    }
    
    if !hints.isEmpty {
        // Show hints
        return .fail(hints: hints, solution: solutionString)
    } else {
        return .pass(message: successString)
    }
}
