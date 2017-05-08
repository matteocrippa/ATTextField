//
//  ATValidatoring.swift
//  smart-rovolon
//
//  Created by Tikhonov on 29/03/2017.
//  Copyright © 2017 Altarix. All rights reserved.
//

import Foundation

public protocol ATValidatoring {
    
    var criterias: [ATCriteriable] { get set }
    init(criterias: [ATCriteriable])
    
    func isValid(forceExit: Bool) -> ATValidatorResult
}
