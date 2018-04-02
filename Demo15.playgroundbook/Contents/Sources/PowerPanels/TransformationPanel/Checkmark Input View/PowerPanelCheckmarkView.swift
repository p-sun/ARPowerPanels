//
//  PowerPanelCheckmarkView.swift
//  ARPowerPanels
//
//  Created by TSD040 on 2018-03-31.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

class PowerPanelCheckmarkView: UIView {
    private let checkmarkImageView = UIImageView()
    
    var isChecked = true {
        didSet {
            updateCheckmark(isChecked: isChecked)
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        setupPowerPanelBorder(tintColor: .uiControlColor)
        
        checkmarkImageView.contentMode = .scaleAspectFit
        addSubview(checkmarkImageView)
        checkmarkImageView.constrainEdges(to: self)
        
        updateCheckmark(isChecked: isChecked)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateCheckmark(isChecked: Bool) {
        checkmarkImageView.image = isChecked ? #imageLiteral(resourceName: "checkmarkWhite") : nil
        backgroundColor = isChecked ? .uiControlColor : .white
    }
}
