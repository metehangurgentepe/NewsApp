//
//  CustomAlertView.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 30.08.2024.
//

import Foundation
import UIKit

class CustomAlertView {
    
    static func showAlert(on viewController: UIViewController, title: String, message: String, buttonTitle: String = LocaleKeys.Error.okButton.rawValue.locale()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonTitle, style: .default)
        alertController.addAction(action)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}

