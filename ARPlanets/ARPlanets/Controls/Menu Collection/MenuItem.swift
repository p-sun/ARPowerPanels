//
//  MenuItem.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-27.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

class MenuItem {
    let name: String
    let viewToPresent: UIView
    let menuTapped: () -> Void
    var isSelected: Bool = false

    init(name: String, viewToPresent: UIView, menuTapped: @escaping () -> Void) {
        self.name = name
        self.viewToPresent = viewToPresent
        self.menuTapped = menuTapped
    }
}
