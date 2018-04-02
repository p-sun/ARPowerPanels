//
//  ImageCollectionCell.swift
//  ARPowerPanels
//
//  Created by TSD040 on 2018-04-01.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addCornerRadius()

        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.constrainEdgesHorizontally(to: self)
        imageView.constrainTop(to: self)
        imageView.constrainBottom(to: self, priority: .defaultHigh)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(image: UIImage?) {
        imageView.image = image
    }
}
