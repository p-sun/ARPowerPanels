//
//  SlidingVectorView.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-22.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

protocol SlidingInputsViewDelegate: class {
    func slidingInputView(didChange value: Float, at index: Int)
}

/// A StackView of a number of SlidingTextViews, with a callback when any of the text views have changed.
class SlidingInputsView: UIView {

    weak var viewDelegate: SlidingInputsViewDelegate?
    
    init(axisLabels: [String], minValue: Float, maxValue: Float) {
        super.init(frame: CGRect.zero)
        
        let stackView = UIStackView()
        
        var firstSlidingInput: SlidingTextView? = nil
        
        for i in 0..<axisLabels.count {
            
            let axisLabel = labelView(text: axisLabels[i])
            axisLabel.constrainWidth(40)
            stackView.addArrangedSubview(axisLabel)
            
            let slidingTextView = makeSlidingTextView(index: i, minValue: minValue, maxValue: maxValue)
            stackView.addArrangedSubview(slidingTextView)
            
            if let firstSlidingInput = firstSlidingInput {
                slidingTextView.constrainWidth(to: firstSlidingInput)
            } else  {
                firstSlidingInput = slidingTextView
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
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }
    
    private func makeSlidingTextView(index: Int, minValue: Float, maxValue: Float) -> SlidingTextView {
        
        let slidingTextView = SlidingTextView(minValue: minValue, maxValue: maxValue)
        slidingTextView.tag = index
        slidingTextView.delegate = self

        return slidingTextView
    }
}

extension SlidingInputsView: SlidingTextViewDelegate {
    func slidingTextView(_ slidingTextView: SlidingTextView, didChange value: Float) {
        viewDelegate?.slidingInputView(didChange: value, at: slidingTextView.tag)
    }
}
