//
//  CarouselItemCell.swift
//  FunctionalTableDataMyDemo
//
//  Created by Pei Sun on 2018-01-09.
//  Copyright © 2018 TribalScale. All rights reserved.
//

import UIKit

public protocol CarouselItemCell where Self: UICollectionViewCell {
    associatedtype ItemModel: Equatable
    static func sizeForItem(model: ItemModel, in collectionView: UICollectionView) -> CGSize
    static func scrollDirection() -> UICollectionViewScrollDirection
    func configure(model: ItemModel)
}

public extension CarouselItemCell {
	static func reuseId() -> String {
		return String(describing: self)
	}
}

/**
 Classes conforming to CarouselItemCells can optionally conform to CarouselItemNibView
 if there is a cooresponding Nib with the same name
*/
public protocol CarouselItemNibView {}

public extension CarouselItemNibView {
	public static func nibWithClassName() -> UINib {
		return UINib(nibName: String(describing: self), bundle: nil)
	}
}
