//
//  SlidingVector3View.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-19.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

class SlidingVector3View: UIView {
    private let stackView = UIStackView()
    let labelTexts: [String]
    
    init(labelTexts: [String]) {
        
        self.labelTexts = labelTexts
        
        super.init(frame: CGRect.zero)
        
        var firstSlidingInput: SlidingInputView? = nil
        for i in 0 ..< 3 {

            let label = labelView(text: labelTexts[i])
            label.constrainWidth(40)
            stackView.addArrangedSubview(label)

            let slidingInput = slidingInputView()
            stackView.addArrangedSubview(slidingInput)
            
            if let firstSlidingInput = firstSlidingInput {
                slidingInput.constrainWidth(to: firstSlidingInput)
            } else  {
                firstSlidingInput = slidingInput
            }
        }

        addSubview(stackView)
        stackView.constrainEdges(to: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func labelView(text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }
    
    private func slidingInputView() -> SlidingInputView {
        let slidingInput = SlidingInputView { value in
            print("Slider | value \(value)")
        }
        slidingInput.minValue = -100
        slidingInput.maxValue = 100
        return slidingInput
    }
    
}
