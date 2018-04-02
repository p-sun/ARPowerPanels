//
//  ImageCollectionView.swift
//  ARPowerPanels
//
//  Created by TSD040 on 2018-04-01.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

protocol ImageCollectionViewDelegate: class {
    func imageCollection(didSelectItemAt index: Int)
}

private extension UICollectionViewCell {
    static func reuseId() -> String {
        return String(describing: self)
    }
}

class ImageCollectionView: UICollectionView {
    
    let images: [UIImage?]
    
    private let cellItemHeight : CGFloat = 40
    private let cellMinLineSpacing : CGFloat = 5
    private let cellMinInteritemSpacing : CGFloat = 20
    private let cellFont = UIFont.boldSystemFont(ofSize: 16)
    
    weak var imageCollectionDelegate: ImageCollectionViewDelegate?
    
    init(images: [UIImage?], frame: CGRect) {
        self.images = images
        
        let layout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseId())
        
        dataSource = self
        delegate = self
        
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageCollectionDelegate?.imageCollection(didSelectItemAt: indexPath.row)
    }
}

extension ImageCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseId(), for: indexPath) as! ImageCollectionViewCell
        let index = indexPath.row
        cell.config(image: images[index])
        return cell
    }
}

extension ImageCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMinLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellMinInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 3
        let itemsWithoutSpacing = bounds.width - CGFloat(numberOfItemsPerRow - 1) * cellMinInteritemSpacing - 20 // TODO make insets custom too
        let widthPerItem = itemsWithoutSpacing / numberOfItemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    private func calculateCellSize(content : NSString) -> CGSize {
        let size: CGSize = content.size(withAttributes: [NSAttributedStringKey.font : cellFont])
        return CGSize(width: size.width + 40, height: cellItemHeight)
    }
}
