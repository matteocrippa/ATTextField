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
            case .ultraLight : return UIFontWeightUltraLight
            case .thin       : return UIFontWeightThin
            case .light      : return UIFontWeightLight
            case .regular    : return UIFontWeightRegular
            case .medium     : return UIFontWeightMedium
            case .semibold   : return UIFontWeightSemibold
            case .bold       : return UIFontWeightBold
            case .heavy      : return UIFontWeightHeavy
            case .black      : return UIFontWeightBlack
            }
        }
        
    }
    
    static func defaultFont(ofSize size: CGFloat, for fontStyle: FontStyle = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: fontStyle.fontStyleWeight)

    }
    
}
