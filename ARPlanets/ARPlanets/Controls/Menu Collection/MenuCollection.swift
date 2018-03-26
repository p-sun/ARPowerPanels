//
//  MenuCollection.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-25.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

struct MenuItem {
    let name: String
    let menuTapped: () -> Void
}

class MenuCollection: UICollectionView {
    
    let menuItems: [MenuItem]
    
    init(menuItems: [MenuItem]) {
        self.menuItems = menuItems
        
        let layout = UICollectionViewFlowLayout()
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        
        MenuCollectionItemCell.register(with: self)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuCollection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("index selected \(indexPath)")
    }
}

extension MenuCollection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MenuCollectionItemCell.dequeueCell(from: collectionView, at: indexPath)
        cell.configure(title: menuItems[indexPath.row].name)
        return cell
    }
}
