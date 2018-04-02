//
//  RoundedButton.swift
//  RoundedButtonMenus
//
//  Created by TSD040 on 2018-03-26.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit

protocol RoundedButtonDelegate: class {
    func roundedButton(didTap button: RoundedButton)
}

class RoundedButton: UIButton {
    
    // MARK: - Variables
    
    var highlightedColor = #colorLiteral(red: 0.3789054537, green: 1, blue: 0.9100258617, alpha: 1) {
        didSet {
            guard oldValue != highlightedColor else {
                return
            }
            setColor()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            guard oldValue != isSelected else {
                return
            }
            setColor()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            guard oldValue != isHighlighted else {
                return
            }
            setColor()
        }
    }
    
    weak var delegate: RoundedButtonDelegate?
    
    private let label = UILabel()
    
    // MARK: - Public Methods
    
    init(hasBlurEffect: Bool = false) {
        super.init(frame: CGRect.zero)
        setupButton()
        if hasBlurEffect {
            setupBlurEffect()
        } else {
            setupWhiteBackground()
        }
        setupLabel()
        setColor()
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {        
        label.text = title
    }
    
    func setFont(_ font: UIFont) {
        label.font = font
    }
    
    // MARK: - Private
    
    private func setupButton() {
        layer.cornerRadius = 18
        layer.borderWidth = 2
        clipsToBounds = true
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.isUserInteractionEnabled = false
        self.addSubview(blurEffectView)
        blurEffectView.constrainEdges(to: self)
    }
    
    private func setupWhiteBackground() {
        let whiteBackground = UIView()
        whiteBackground.isUserInteractionEnabled = false
        whiteBackground.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        self.addSubview(whiteBackground)
        whiteBackground.constrainEdges(to: self)
    }
    
    private func setupLabel() {
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(label)
        label.constrainEdges(to: self, insets: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
    }
    
    private func setColor() {
        let shouldHaveColor = !isSelected && isHighlighted || isSelected && !isHighlighted
        let color = shouldHaveColor ? highlightedColor : .white
        label.textColor = color
        layer.borderColor = color.cgColor
    }

    @objc func tapped() {
        isSelected = !isSelected
        delegate?.roundedButton(didTap: self)
    }
}
