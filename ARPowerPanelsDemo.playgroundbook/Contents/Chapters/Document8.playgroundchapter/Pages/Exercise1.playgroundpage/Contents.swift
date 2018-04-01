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
let x = 10
//#-end-hidden-code

//#-editable-code Tap to enter code
import UIKit
import PlaygroundSupport

// Present the view controller in the Live View window
//let liveController = UINavigationController(rootViewController: ExampleViewController())
//liveController.preferredContentSize = CGSize(width: 320, height: 420)
PlaygroundPage.current.liveView = ARKitViewController(panelTypes: ARPowerPanelsType.allTypes)

//#-end-editable-code

