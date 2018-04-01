//
//  UICollection+Extensions.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-25.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

protocol DequeueableCollectionViewCell {
    associatedtype CellType
    static func register(with collectionView: UICollectionView)
    static func dequeueCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> CellType
}

extension DequeueableCollectionViewCell where Self: UICollectionViewCell {
    static func register(with collectionView: UICollectionView) {
        collectionView.register(Self.self, forCellWithReuseIdentifier: Self.reuseId())
    }
    
    static func dequeueCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> Self {
        return collectionView.dequeueReusableCell(withReuseIdentifier: Self.reuseId(), for: indexPath) as! Self
    }
    
    private static func reuseId() -> String {
        return String(describing: self)
    }
}
