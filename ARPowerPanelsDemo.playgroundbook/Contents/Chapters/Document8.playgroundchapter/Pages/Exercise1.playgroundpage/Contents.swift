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

class ViewController: UIViewController {
    
    private var greenViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        let greenView = makeGreenView()
        view.addSubview(greenView)
        greenView.constrainHeight(300)
        greenView.constrainWidth(300)
        greenViewTopConstraint = greenView.constrainTop(to: view, offset: 60)
        greenView.constrainCenterX(to: view)
        
        let yellowButton = makeYellowButton()
        view.addSubview(yellowButton)
        yellowButton.constrainHeight(80)
        yellowButton.constrainTopToBottom(of: greenView, offset: 30)
        yellowButton.constrainLeading(to: greenView)
    }
    
    private func makeYellowButton() -> UIView {
        let yellowButton = UIButton()
        yellowButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        yellowButton.addTarget(self, action: #selector(yellowButtonPressed), for: .touchUpInside)
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.text = "Move ❇️ down by 20"
        yellowButton.addSubview(label)
        label.constrainEdges(to: yellowButton, insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        yellowButton.addSubview(label)
        
        return yellowButton
    }
    
    private func makeGreenView() -> UIView {
        let greenView = UIView()
        greenView.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        
        let roseImage = #imageLiteral(resourceName: "rose.jpg")
        let imageView = UIImageView()
        imageView.image = roseImage
        greenView.addSubview(imageView)
        imageView.constrainAspectRatio(to: roseImage.size)
        imageView.constrainEdgesHorizontally(to: greenView, leftInsets: 20, rightInsets: 20)
        imageView.constrainCenterY(to: greenView)
        
        return greenView
    }
    
    @objc private func yellowButtonPressed() {
        UIView.animate(withDuration: 0.3) {
            self.greenViewTopConstraint.constant += 20
            self.view.layoutIfNeeded()
        }
    }
}

// Present the view controller in the Live View window
//let liveController = UINavigationController(rootViewController: ExampleViewController())
//liveController.preferredContentSize = CGSize(width: 320, height: 420)
PlaygroundPage.current.liveView = ViewController()

//#-end-editable-code

