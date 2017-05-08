//
//  ATValidator.swift
//  smart-rovolon
//
//  Created by Tikhonov on 29/03/2017.
//  Copyright © 2017 Altarix. All rights reserved.
//

import Foundation

public struct ATValidator: ATValidatoring {
    
    public var criterias: [ATCriteriable]
    
    public init(criterias: [ATCriteriable] = []) {
        self.criterias = criterias
    }
    
    public func isValid(forceExit: Bool = true) -> ATValidatorResult {
        if forceExit == true {
            guard let index = criterias.index(where: { $0.isConform() == false }) else { return .valid }
            return .notValid(criteria: criterias[index])
        } else {
            let crits = criterias.filter{ $0.isConform() == false }
            if crits.isEmpty == false {
                return .notValides(criterias: crits)
            } else {
                return .valid
            }
        }
    }
}
