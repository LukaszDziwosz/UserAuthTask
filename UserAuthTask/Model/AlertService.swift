//
//  AlertService.swift
//  UserAuthTask
//
//  Created by Lukasz Dziwosz on 22/08/2021.
//

import UIKit

class AlertService {
    
    func alert(message: String, handler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: handler)
        
        alert.addAction(action)
        
        return alert
    }
}
