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

/// A StackView of any number of SlidingTextViews, with a delegate callback to pass values back when they've changed.
class SlidingInputsView: UIView {

    weak var viewDelegate: SlidingInputsViewDelegate?
    
    private var textViews = [SlidingTextView]()

    init(axisLabels: [String], minValue: Float, maxValue: Float) {
        super.init(frame: CGRect.zero)

        let stackView = UIStackView()

        for i in 0..<axisLabels.count {
            
            let axisLabel = labelView(text: axisLabels[i])
            axisLabel.constrainWidth(40)
            stackView.addArrangedSubview(axisLabel)
            
            let slidingTextView = makeSlidingTextView(index: i, minValue: minValue, maxValue: maxValue)
            textViews.append(slidingTextView)
            stackView.addArrangedSubview(slidingTextView)
            
            if let firstSlidingInput = textViews.first {
                slidingTextView.constrainWidth(to: firstSlidingInput)
            }
        }
        
        addSubview(stackView)
        stackView.constrainEdges(to: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(_ value: Float, atIndex: Int) {
        print("SlidingInputsView set value \(value) at index \(atIndex)")
        textViews[atIndex].value = value
    }
    
    func setPanSpeed(_ speed: Float) {
        for textView in textViews {
            textView.panSpeed = speed
        }
    }
    
    private func labelView(text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.text = text
        label.font = UIFont.inputSlider
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
