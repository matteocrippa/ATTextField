//
//  ATValidatorResult.swift
//  smart-rovolon
//
//  Created by Tikhonov on 29/03/2017.
//  Copyright © 2017 Altarix. All rights reserved.
//

import Foundation

public enum ATValidatorResult {
    case valid
    case notValid(criteria: ATCriteriable)
    case notValides(criterias: [ATCriteriable])
    
    var boolValue: Bool {
        switch self {
        case .valid:
            return true
        default:
            return false
        }
    }
}
