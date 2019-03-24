////
////  CarouselCell.swift
////  FunctionalTableDataMyDemo
////
////  Created by Paige Sun on 2018-01-16.
////  Copyright © 2018 TribalScale. All rights reserved.
////

import UIKit

public class CarouselCell<T: CarouselItemCell>: CellConfigType {
    public var key: String
    public var style: CellStyle?
    public var actions: CellActions
    private var state: CarouselState<T>
    
    private typealias TableViewCellType = TableCell<CarouselView<T>, EdgeBasedTableItemLayout>
    
    private var tableLayoutMargins = UIEdgeInsets.zero

    public init(key: String, style: CellStyle? = nil, state: CarouselState<T>, actions: CellActions = CellActions()) {
        self.key = key
        self.style = style
        self.state = state
        self.actions = actions
    }

    public func register(with tableView: UITableView) {
        tableLayoutMargins = tableView.layoutMargins
        tableLayoutMargins.top = tableView.layoutMargins.left
        tableLayoutMargins.bottom = tableView.layoutMargins.left
        
        tableView.registerReusableCell(TableViewCellType.self)
    }
    
    public func dequeueCell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TableViewCellType.self, indexPath: indexPath)
        
        // Prepare for reuse if needed
        // CarouselState<T>.updateView(cell.view, state: nil)
        
        return cell
    }
    
    public func update(cell: UITableViewCell, in tableView: UITableView) {
        guard let carouselCell = cell as? TableViewCellType else { return }
        
        carouselCell.view.setContentInset(tableLayoutMargins)
        CarouselState<T>.updateView(carouselCell.view, state: state)
        
        // Only layout cells that aren't in the reuse pool
        if cell.superview != nil && !cell.isHidden {
            UIView.performWithoutAnimation {
                cell.layoutIfNeeded()
            }
        }
    }
    
    public func isEqual(_ other: CellConfigType) -> Bool {
        if let other = other as? CarouselCell<T> {
            return state == other.state
        }
        return false
    }
    
    public func debugInfo() -> [String : Any] {
        return [:]
    }
    
    public func register(with collectionView: UICollectionView) {
        // Not applicable -- no reason to have a collectionView in a collectionView
    }
    
    public func update(cell: UICollectionViewCell, in collectionView: UICollectionView) {
        // Not applicable -- no reason to have a collectionView in a collectionView
    }
}

