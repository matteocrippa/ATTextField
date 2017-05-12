//
//  ATEmptyCriteriable.swift
//  testttt
//
//  Created by tikhonov on 11/05/2017.
//  Copyright © 2017 tikhonov. All rights reserved.
//

import UIKit
import ATTextField

struct ATEmptyCriteria: ATCriteriable {
    var error: Error? = ATError()
    
    var textField: UITextField!
    
    func isConform() -> Bool {
        return textField.text!.isEmpty == false
    }
}

class ATError: Error, LocalizedError {
    var errorDescription: String? {
        return "Something went wrong"
    }
}
