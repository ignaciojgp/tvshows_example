//
//  TVShow.swift
//  tv shows
//
//  Created by Ignacio J Gonzalez Pérez on 23/01/21.
//

import UIKit
import CoreData

public struct RemoteTVShow: Codable {
    
    var id: Int64
    var name: String?
    var summary:String?
    var image: Image
    var externals: Externals
    
}

public struct Image: Codable{
    var medium: String?
    var original: String?
}

public struct Externals: Codable{
    var tvrage: Int64?
    var thetvdb: Int64?
    var imdb:String?
}
