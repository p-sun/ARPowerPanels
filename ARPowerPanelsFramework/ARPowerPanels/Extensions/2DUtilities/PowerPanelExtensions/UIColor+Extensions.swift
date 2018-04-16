//
//  UIColor+Extensions.swift
//  ARPlanets
//
//  Created by TSD040 on 2018-03-24.
//  Copyright © 2018 Pei Sun. All rights reserved.
//

import UIKit

extension UIColor {
    static var xAxisColor: UIColor {
        return #colorLiteral(red: 0.9098039269, green: 0.2054645958, blue: 0.4377822972, alpha: 1)
    }
    
    static var yAxisColor: UIColor {
        return #colorLiteral(red: 0.506713325, green: 0.8235294223, blue: 0.195811117, alpha: 1)
    }

    static var zAxisColor: UIColor {
        return #colorLiteral(red: 0.09368573094, green: 0.5884961087, blue: 0.9686274529, alpha: 1)
    }

    static var wAxisColor: UIColor {
        return #colorLiteral(red: 0.9568627477, green: 0.8079159167, blue: 0.2590701966, alpha: 1)
    }
    
    static var uiControlColor: UIColor {
        return #colorLiteral(red: 0.3789054537, green: 1, blue: 0.9100258617, alpha: 1) 
    }
    
    static var panelBackgroundColor: UIColor {
        return #colorLiteral(red: 0, green: 0.1417405471, blue: 0.2871974469, alpha: 0.4654668328)
    }
}

public extension UIColor {
    public static func randomColor() -> UIColor {
        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
