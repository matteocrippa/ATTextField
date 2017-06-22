//
//  UIColor.swift
//  smart-rovolon
//
//  Created by Tikhonov on 8/28/16.
//  Copyright © 2016 Alexander Tikhonov. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(withHexString hex: String, alpha: CGFloat = 1.0) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }
        var hexInt: Int = 0
        Scanner(string: hex).scanInt(&hexInt)
        self.init(hex: hexInt, alpha: alpha)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let colorComponents = (
            red: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 08) & 0xff) / 255,
            blue: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(
            red: colorComponents.red,
            green: colorComponents.green,
            blue: colorComponents.blue,
            alpha: alpha
        )
    }
}

extension UIColor {
    
    // Palette
    static let pallette0 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // FFFFFF
    static let pallette1 = #colorLiteral(red: 0.9490196078, green: 0.9568627451, blue: 0.9843137255, alpha: 1) // F2F4FB
    
    static let pallette2 = #colorLiteral(red: 0.5176470588, green: 0.5607843137, blue: 0.6666666667, alpha: 1) // 848FAA
    static let pallette3 = #colorLiteral(red: 0.3352941176, green: 0.3294117647, blue: 0.4352941176, alpha: 1) // 3C546F
    
    static let pallette4 = #colorLiteral(red: 0.3862745098, green: 0.7254901961, blue: 0.4901960784, alpha: 1) // 49B97D
    static let pallette5 = #colorLiteral(red: 0.4745098039, green: 0.7647058824, blue: 0.6078431373, alpha: 1) // 79C39B
    
    static let pallette6 = #colorLiteral(red: 0.8392156863, green: 0.8431372549, blue: 0.8509803922, alpha: 1) // D6D7D9
    
    static let pallette7 = #colorLiteral(red: 0.9254901961, green: 0.4039215686, blue: 0.5568627451, alpha: 1) // EC678E

}
