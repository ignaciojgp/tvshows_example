//
//  BrowserHelper.swift
//  tv shows
//
//  Created by Ignacio J Gonzalez Pérez on 24/01/21.
//

import UIKit

class BrowserHelper: NSObject {
    static func openIMDB(id:String){
        guard let url = URL(string: "https://www.imdb.com/title/\(id)") else {return}
        
        UIApplication.shared.open(url, options: [:],
          completionHandler: {
              (success) in
                 print("Open IMDB: \(success)")
          })

    }
}
