//
//  ATCriteriable.swift
//  smart-rovolon
//
//  Created by Tikhonov on 29/03/2017.
//  Copyright © 2017 Altarix. All rights reserved.
//

import Foundation

public protocol ATCriteriable {
    
    var error: Error? { set get }
    
    func isConform() -> Bool
}
