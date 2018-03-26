//
//  SliderInputsView.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-22.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit

protocol SliderInputsViewDelegate: class {
    func sliderInputView(didChange value: Float, at index: Int)
}

/// A StackView of any number of SliderTextViews, with a delegate callback to pass values back when they've changed.
class SliderInputsView: UIView {

    weak var viewDelegate: SliderInputsViewDelegate?
    
    private var textViews = [SliderTextView]()

    private let textColors: [UIColor] = [.xAxisColor, .yAxisColor, .zAxisColor, .wAxisColor]
    
    init(axisLabels: [String], minValue: Float, maxValue: Float) {
        super.init(frame: CGRect.zero)

        self.constrainHeight(29)
        
        let stackView = UIStackView()

        for i in 0..<axisLabels.count {
            
            let axisLabel = labelView(text: axisLabels[i], color: textColors[i])
            axisLabel.constrainWidth(40)
            stackView.addArrangedSubview(axisLabel)
            
            let sliderTextView: SliderTextView
            sliderTextView = makeSliderTextView(index: i, minValue: minValue, maxValue: maxValue)
            textViews.append(sliderTextView)
            stackView.addArrangedSubview(sliderTextView)
            
            if let firstSliderInput = textViews.first {
                sliderTextView.constrainWidth(to: firstSliderInput)
            }
        }
        
        addSubview(stackView)
        stackView.constrainEdges(to: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(_ value: Float, atIndex: Int) {
//        print("SliderInputsView set value \(value) at index \(atIndex)")
        textViews[atIndex].value = value
    }
    
    func setPanSpeed(_ speed: Float) {
        for textView in textViews {
            textView.panSpeed = speed
        }
    }
    
    private func labelView(text: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.text = text
        label.font = UIFont.inputSliderAxisLabel
        label.textColor = color
        return label
    }
    
    private func makeSliderTextView(index: Int, minValue: Float, maxValue: Float) -> SliderTextView {
        
        let sliderTextView = SliderTextView(minValue: minValue, maxValue: maxValue)
        sliderTextView.tag = index
        sliderTextView.delegate = self

        return sliderTextView
    }
}

extension SliderInputsView: SliderTextViewDelegate {
    func sliderTextView(_ sliderTextView: SliderTextView, didChange value: Float) {
        viewDelegate?.sliderInputView(didChange: value, at: sliderTextView.tag)
    }
}
