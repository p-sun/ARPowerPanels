//
//  SlidingVector3View.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-19.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

class SlidingVector3View: UIView {
    let stackView = UIStackView()
    
    init() {
        super.init(frame: CGRect.zero)
        
        var firstSlidingInput: SlidingInputView? = nil
        for i in 0 ..< 3 {
            let slidingInput = SlidingInputView { value in
                print("Slider \(i) | value \(value)")
            }
            slidingInput.minValue = -1000
            slidingInput.maxValue = 1000
            
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
}
