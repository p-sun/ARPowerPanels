//
//    MIT License
//
//    Copyright (c) 2018 Paige Sun <paige.sun.dev@gmail.com>
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.
//
//  A simplified version of https://github.com/roberthein/TinyConstraints

import UIKit

enum ConstraintRelation: Int {
    case equal = 0
    case equalOrLess = -1
    case equalOrGreater = 1
}

extension UIView {
    
    // MARK: - Compound Constraints
    
    func addSubviewsForAutolayout(_ views: UIView...) {
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
    @discardableResult
    func constrainEdges(to otherview: UIView, insets: UIEdgeInsets = .zero, usingSafeArea: Bool = false) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        let constrainable = safeConstrainable(for: otherview, usingSafeArea: usingSafeArea)
        constraints.append(
            constrainTop(to: constrainable, nil, offset: insets.top)
        )

        constraints.append(
            constrainBottom(to: constrainable, nil, offset: -insets.bottom)
        )
        
        constrainEdgesHorizontally(to: otherview, leftInsets: insets.left, rightInsets: insets.right, usingSafeArea: usingSafeArea)
        
        return constraints
    }
    
    @discardableResult
    func constrainEdgesHorizontally(to otherview: UIView, leftInsets: CGFloat = 0, rightInsets: CGFloat = 0, usingSafeArea: Bool = false) -> [NSLayoutConstraint] {
        prepareForAutolayout()
        
        var constraints = [NSLayoutConstraint]()
        
        let constrainable = safeConstrainable(for: otherview, usingSafeArea: usingSafeArea)
        constraints.append(
            constrainLeft(to: constrainable, nil, offset: leftInsets)
        )
        constraints.append(
            constrainRight(to: constrainable, nil, offset: -rightInsets)
        )
        return constraints
    }
    
    @discardableResult
    func constrainEdgesVertically(to otherview: UIView, topInsets: CGFloat = 0, bottomInsets: CGFloat = 0, usingSafeArea: Bool = false) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        let constrainable = safeConstrainable(for: otherview, usingSafeArea: usingSafeArea)
        constraints.append(
            constrainTop(to: constrainable, nil, offset: topInsets)
        )
        constraints.append(
            constrainBottom(to: constrainable, nil, offset: -bottomInsets)
        )
        return constraints
    }
    
    
    func safeConstrainable(for otherview: UIView?, usingSafeArea: Bool) -> Constrainable {
        guard let otherview = otherview else {
            fatalError("View is nil!")
        }
        prepareForAutolayout()
        
        if #available(iOS 11, tvOS 11, *){
            if usingSafeArea {
                return otherview.safeAreaLayoutGuide
            }
        }
        
        return otherview
    }
    
    @discardableResult
    func constrainSize(_ size: CGSize, priority: UILayoutPriority = .required, isActive: Bool = true) -> [NSLayoutConstraint] {
        prepareForAutolayout()
        
        let constraints = [
            widthAnchor.constraint(equalToConstant: size.width).with(priority),
            heightAnchor.constraint(equalToConstant: size.height).with(priority)
        ]
        
        if isActive {
            NSLayoutConstraint.activate(constraints)
        }
        
        return constraints
    }
    
    @discardableResult
    func constrainSize(to view: Constrainable, multiplier: CGFloat = 1, offset: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> [NSLayoutConstraint] {
        prepareForAutolayout()
        
        let constraints = [
            widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: offset).with(priority),
            heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier, constant: offset).with(priority)
        ]
        
        if isActive {
            NSLayoutConstraint.activate(constraints)
        }
        
        return constraints
    }
    
    @discardableResult
    func constrainAspectRatio(to size: CGSize, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        return heightAnchor.constraint(equalTo: widthAnchor,
                                       multiplier: size.height/size.width).set(active: isActive)
    }
    
    // MARK: - Basic Elemental Constraints
    
    @discardableResult
    func constrainWidth(_ width: CGFloat, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        
        switch relation {
        case .equal: return widthAnchor.constraint(equalToConstant: width).with(priority).set(active: isActive)
        case .equalOrLess: return widthAnchor.constraint(lessThanOrEqualToConstant: width).with(priority).set(active: isActive)
        case .equalOrGreater: return widthAnchor.constraint(greaterThanOrEqualToConstant: width).with(priority).set(active: isActive)
        }
    }
    
    @discardableResult
    func constrainWidth(to view: Constrainable, _ dimension: NSLayoutDimension? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        
        switch relation {
        case .equal: return widthAnchor.constraint(equalTo: dimension ?? view.widthAnchor, multiplier: multiplier, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return widthAnchor.constraint(lessThanOrEqualTo: dimension ?? view.widthAnchor, multiplier: multiplier, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return widthAnchor.constraint(greaterThanOrEqualTo: dimension ?? view.widthAnchor, multiplier: multiplier, constant: offset).with(priority).set(active: isActive)
        }
    }
    
    @discardableResult
    func constrainHeight(_ height: CGFloat, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        
        switch relation {
        case .equal: return heightAnchor.constraint(equalToConstant: height).with(priority).set(active: isActive)
        case .equalOrLess: return heightAnchor.constraint(lessThanOrEqualToConstant: height).with(priority).set(active: isActive)
        case .equalOrGreater: return heightAnchor.constraint(greaterThanOrEqualToConstant: height).with(priority).set(active: isActive)
        }
    }
    
    @discardableResult
    func constrainHeight(to view: Constrainable, _ dimension: NSLayoutDimension? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        
        switch relation {
        case .equal: return heightAnchor.constraint(equalTo: dimension ?? view.heightAnchor, multiplier: multiplier, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return heightAnchor.constraint(lessThanOrEqualTo: dimension ?? view.heightAnchor, multiplier: multiplier, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return heightAnchor.constraint(greaterThanOrEqualTo: dimension ?? view.heightAnchor, multiplier: multiplier, constant: offset).with(priority).set(active: isActive)
        }
    }
    
    @discardableResult
    func constrainLeadingToTrailing(of view: Constrainable, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        return constrainLeading(to: view, view.trailingAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    @discardableResult
    func constrainLeading(to view: Constrainable, _ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        
        switch relation {
        case .equal: return leadingAnchor.constraint(equalTo: anchor ?? view.leadingAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return leadingAnchor.constraint(lessThanOrEqualTo: anchor ?? view.leadingAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return leadingAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.leadingAnchor, constant: offset).with(priority).set(active: isActive)
        }
    }
    
    @discardableResult
    func constrainLeftToRight(of view: Constrainable, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        return constrainLeft(to: view, view.rightAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    @discardableResult
    func constrainLeft(to view: Constrainable, _ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        
        switch relation {
        case .equal: return leftAnchor.constraint(equalTo: anchor ?? view.leftAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return leftAnchor.constraint(lessThanOrEqualTo: anchor ?? view.leftAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return leftAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.leftAnchor, constant: offset).with(priority).set(active: isActive)
        }
    }
    
    @discardableResult
    func constrainTrailingToLeading(of view: Constrainable, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        return constrainTrailing(to: view, view.leadingAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    @discardableResult
    func constrainTrailing(to view: Constrainable, _ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        
        switch relation {
        case .equal: return trailingAnchor.constraint(equalTo: anchor ?? view.trailingAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return trailingAnchor.constraint(lessThanOrEqualTo: anchor ?? view.trailingAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return trailingAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.trailingAnchor, constant: offset).with(priority).set(active: isActive)
        }
    }
    
    @discardableResult
    func constrainRightToLeft(of view: Constrainable, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        return constrainRight(to: view, view.leftAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    @discardableResult
    func constrainRight(to view: Constrainable, _ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        
        switch relation {
        case .equal: return rightAnchor.constraint(equalTo: anchor ?? view.rightAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return rightAnchor.constraint(lessThanOrEqualTo: anchor ?? view.rightAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return rightAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.rightAnchor, constant: offset).with(priority).set(active: isActive)
        }
    }
    
    @discardableResult
    func constrainTopToBottom(of view: Constrainable, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        return constrainTop(to: view, view.bottomAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    @discardableResult
    func constrainTop(to view: Constrainable, _ anchor: NSLayoutYAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        
        switch relation {
        case .equal: return topAnchor.constraint(equalTo: anchor ?? view.topAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return topAnchor.constraint(lessThanOrEqualTo: anchor ?? view.topAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return topAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.topAnchor, constant: offset).with(priority).set(active: isActive)
        }
    }
    
    /// Constrain to all sides, within the safe area.
    /// NOTE: Not true for the bottom. TODO
    @discardableResult
    func constrainWithinLayoutGuide(of viewController: UIViewController, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        let topConstraint = constrainTopToTopLayoutGuide(of: viewController, inset: insets.top)
        let horizontalConstraints = constrainEdgesHorizontally(to: viewController.view, leftInsets: insets.left, rightInsets: insets.right)
        let bottomConstraint = constrainBottom(to: viewController.view, offset: -insets.bottom)
        return [topConstraint] + horizontalConstraints + [bottomConstraint]
    }
    
    @discardableResult
    func constrainTopToTopLayoutGuide(of viewController: UIViewController, inset: CGFloat = 0) -> NSLayoutConstraint {
        prepareForAutolayout()
        
        let topConstraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            topConstraint = topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: inset)
            topConstraint.isActive = true
        } else {
            topConstraint = topAnchor.constraint(equalTo: viewController.topLayoutGuide.bottomAnchor, constant: inset)
            topConstraint.isActive = true
        }
        return topConstraint
    }

    
    @discardableResult
    func constrainBottomToTop(of view: Constrainable, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        return constrainBottom(to: view, view.topAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }
    
    @discardableResult
    func constrainBottom(to view: Constrainable, _ anchor: NSLayoutYAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        
        switch relation {
        case .equal: return bottomAnchor.constraint(equalTo: anchor ?? view.bottomAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return bottomAnchor.constraint(lessThanOrEqualTo: anchor ?? view.bottomAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return bottomAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.bottomAnchor, constant: offset).with(priority).set(active: isActive)
        }
    }
    
    @discardableResult
    func constrainCenterX(to view: Constrainable, _ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        
        let constraint = centerXAnchor.constraint(equalTo: anchor ?? view.centerXAnchor, constant: offset).with(priority)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    func constrainCenterY(to view: Constrainable, _ anchor: NSLayoutYAxisAnchor? = nil, offset: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        prepareForAutolayout()
        
        let constraint = centerYAnchor.constraint(equalTo: anchor ?? view.centerYAnchor, constant: offset).with(priority)
        constraint.isActive = isActive
        return constraint
    }
}
