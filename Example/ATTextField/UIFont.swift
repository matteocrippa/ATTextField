//
//  UIFont.swift
//  smart-rovolon
//
//  Created by Tikhonov on 8/13/16.
//  Copyright © 2016 Alexander Tikhonov. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum FontStyle {
        case ultraLight
        case thin
        case light
        case regular
        case medium
        case semibold
        case bold
        case heavy
        case black
        // you can add another cases corresponding your font
        
        var fontStyleWeight: CGFloat {
            switch self {
            case .ultraLight : return UIFont.Weight.ultraLight.rawValue
            case .thin       : return UIFont.Weight.thin.rawValue
            case .light      : return UIFont.Weight.light.rawValue
            case .regular    : return UIFont.Weight.regular.rawValue
            case .medium     : return UIFont.Weight.medium.rawValue
            case .semibold   : return UIFont.Weight.semibold.rawValue
            case .bold       : return UIFont.Weight.bold.rawValue
            case .heavy      : return UIFont.Weight.heavy.rawValue
            case .black      : return UIFont.Weight.black.rawValue
            }
        }
        
    }
    
    static func defaultFont(ofSize size: CGFloat, for fontStyle: FontStyle = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight(rawValue: fontStyle.fontStyleWeight))
    }
    
}
