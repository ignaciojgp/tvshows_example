//
//  AlertHelper.swift
//  tv shows
//
//  Created by Ignacio J Gonzalez Pérez on 24/01/21.
//

import UIKit

enum AlertHelperMessage:String{
    case saveMessage = "There was a problem saving this TV Show. Do you want to try again?"
    case deleteMessage = "There was a problem deleting this TV Show. Do you want to try again?"
    case fetch = "An error occurred while fetching data. Do you want to try again?"
}

class AlertHelper: NSObject {
    static func showRetryAlert( viewController:UIViewController, message: AlertHelperMessage, onChooseRetry:@escaping ()->Void){
        
        
        
        let alert = UIAlertController(title: "Oops, something went wrong", message: message.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
            onChooseRetry()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            print("delete canceled")
        }))
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true) {
                //not doing anything
            }
        }
        
    }
}
