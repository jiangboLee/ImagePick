//
//  UIColor+Extension.swift
//  ImagePick
//
//  Created by Lee on 2018/8/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

import UIKit

extension UIColor {
    
    public convenience init(r : CGFloat, g : CGFloat, b : CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    public convenience init(hexString: String, alpha: Float = 1.0) {
        var hex = hexString
        
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1) ..< hex.endIndex])
        }
        if hex.hasPrefix("0x") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2) ..< hex.endIndex])
        }
        guard let hexVal = Int(hex, radix: 16) else {
            self.init(white: 1.0, alpha: 1.0)
            return
        }
        
        switch hex.count {
        case 6:
            self.init(hex6: hexVal, alpha: alpha)
        case 8:
            self.init(hex8: UInt64(hexVal), alpha: alpha)
        default:
            self.init(white: 1.0, alpha: 1.0)
        }
    }
    
    fileprivate convenience init(hex6: Int, alpha: Float) {
        self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
    }
    
    fileprivate convenience init(hex8: UInt64, alpha: Float) {
        let red = CGFloat( (hex8 & 0xFF000000) >> 24 ) / 255.0
        let green = CGFloat( (hex8 & 0x00FF0000) >> 16 ) / 255.0
        let blue = CGFloat( (hex8 & 0x0000FF00) >> 8 ) / 255.0
        let alp = CGFloat( (hex8 & 0x000000FF) >> 0 ) / 255.0
        self.init(red:   red,
                  green: green,
                  blue:  blue,
                  alpha: alp)
    }
}
