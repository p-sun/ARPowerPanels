//
//  MenuItem.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-27.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

struct MenuItem {
    let stackItem: MenuStackItem // For the MenuStack on the left with menu buttons
    let panelItem: PanelItem
    
    init(name: String, panelItem: PanelItem) {
        self.stackItem = MenuStackItem(name: name)
        self.panelItem = panelItem
    }
}
