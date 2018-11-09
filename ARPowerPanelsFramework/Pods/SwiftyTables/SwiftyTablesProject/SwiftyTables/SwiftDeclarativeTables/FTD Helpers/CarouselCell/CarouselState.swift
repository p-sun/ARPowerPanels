//
//  CarouselView.swift
//  FunctionalTableDataMyDemo
//
//  Created by Paige Sun on 2018-01-17.
//  Copyright © 2018 TribalScale. All rights reserved.
//

/* NOTE: if collectionHeight < item height, the app will enter a loop.
 Set a symbolic breakpoint at UICollectionViewFlowLayoutBreakForInvalidSizes to catch it.
 **/

import UIKit

public struct CarouselState<ItemCell: CarouselItemCell>: StateType, Equatable {
    
    public typealias View = CarouselView<ItemCell>
    
    fileprivate let itemModels: [ItemCell.ItemModel]
    fileprivate let didSelectItemCell: ((IndexPath) -> Void)?
    fileprivate let collectionHeight: CGFloat
    
    public init(itemModels: [ItemCell.ItemModel],
         collectionHeight: CGFloat,
         didSelectItemCell: ((IndexPath) -> Void)?) {
        
        self.itemModels = itemModels
        self.collectionHeight = collectionHeight
        self.didSelectItemCell = didSelectItemCell
    }
    
    public static func updateView(_ view: View, state: CarouselState?) {
        guard let state = state else {
            // Prepare for reuse if needed
            return
        }
        
        view.reload(state: state)
    }
    
    public static func ==(lhs: CarouselState<ItemCell>, rhs: CarouselState<ItemCell>) -> Bool {
        var equality = lhs.itemModels == rhs.itemModels
        equality = equality && lhs.collectionHeight == rhs.collectionHeight
        return equality
    }
}

public class CarouselView<ItemCell: CarouselItemCell>: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public var carouselOffset: CGFloat {
        get {
            return collectionView.contentOffset.x + collectionView.contentInset.left
        }
        set {
            collectionView.contentOffset.x = newValue - collectionView.contentInset.left
        }
    }
    
    private var state: CarouselState<ItemCell>?
    private var cellHeightConstraint: NSLayoutConstraint!
    
    private var collectionView: UICollectionView!
    
    public init() {
        super.init(frame: CGRect.zero)
        
//        let redView = UIView()
//        redView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//        addSubview(redView)
//        redView.constrainToFillView(self)
        
        collectionView = createCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if ItemCell.scrollDirection() == .vertical {
            collectionView.isScrollEnabled = false
        }
        
        self.addSubview(collectionView)
        collectionView.pinToSuperView()
        
        cellHeightConstraint = self.heightAnchor.constraint(equalToConstant: 200)
        cellHeightConstraint.isActive = true
        
        if let itemCell = ItemCell.self as? CarouselItemNibView.Type {
            collectionView.register(itemCell.nibWithClassName(), forCellWithReuseIdentifier: ItemCell.reuseId())
        } else {
            collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseId())
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    public func setContentInset(_ insets: UIEdgeInsets) {
        print("setting content inset \(insets)")
        var newInset = insets
        newInset.top = 0
        collectionView.contentInset = insets
    }
    
    public func reload(state: CarouselState<ItemCell>) {
        // Stops collection view if it was scrolling.
        collectionView.setContentOffset(collectionView.contentOffset, animated:false)
        collectionView.cancelInteractiveMovement()
        cellHeightConstraint.constant = state.collectionHeight
        self.state = state
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionView Delegates
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // This is to prevent a crash that happens on fresh install when the collectionView height is 44, and therefore smaller than the item size
        guard collectionView.bounds.size.height == state?.collectionHeight else { return 0 }
        
        return self.state?.itemModels.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseId(), for: indexPath) as? ItemCell, let state = state {
			cell.tag = indexPath.row
			let model = state.itemModels[indexPath.row]
            cell.configure(model: model)
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        state?.didSelectItemCell?(indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let state = state else { return CGSize.zero }
		let model = state.itemModels[indexPath.row]
		return ItemCell.sizeForItem(model: model, in: collectionView)
    }
    
    // MARK: - Private
    private func createCollectionView() -> UICollectionView {
        // NOTE: Do NOT set minimumLineSpacing in the flow layout because the collectionView's contentSize will not size correctly. If absolutely needed, set spacing in your item cells instead.
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = ItemCell.scrollDirection()
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }
}
