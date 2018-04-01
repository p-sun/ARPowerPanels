//
//  ModelCollectionView.swift
//  ARPowerPanels
//
//  Created by TSD040 on 2018-04-01.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

protocol ModelCollectionViewDelegate: class {
    func modelCollectionView(_ modelCollectionView: ModelCollectionView, didSelectIndex: Int)
}

class ModelCollectionView: UIView {
    
    weak var delegate: ModelCollectionViewDelegate?
    
    private let imageCollectionView: ImageCollectionView

    init(frame: CGRect, models: [NodeMaker]) {
        let images = models.map { $0.menuImage }
        imageCollectionView = ImageCollectionView(images: images, frame: frame)
        
        super.init(frame: frame)
        
        let closeButton = UIButton()
        closeButton.setImage(#imageLiteral(resourceName: "closeWhite"), for: .normal)
        addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        closeButton.constrainTop(to: self)
        closeButton.constrainLeft(to: self)
        closeButton.constrainSize(CGSize(width: 40, height: 40))

        imageCollectionView.imageCollectionDelegate = self
        
        addSubview(imageCollectionView)
        imageCollectionView.constrainTopToBottom(of: closeButton)
        imageCollectionView.constrainEdgesHorizontally(to: self)
        imageCollectionView.constrainBottom(to: self, priority: .defaultLow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeButtonPressed() {
        removeFromSuperview()
    }
}

extension ModelCollectionView: ImageCollectionViewDelegate {
    func imageCollection(didSelectItemAt index: Int) {
        print("did select index \(index)")
    }
}
