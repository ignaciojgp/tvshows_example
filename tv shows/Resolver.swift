//
//  Resolver.swift
//  tv shows
//
//  Created by Ignacio J Gonzalez Pérez on 23/01/21.
//

import UIKit


public class Resolver: NSObject {
    
    public var remoteDataHelper: RemoteDataHelper = RemoteDataHelper()
    public var localDataHelper: LocalDataHelper = LocalDataHelper()
    public var allShowListService = AllShowListService()
    public var favouritesShowsListService = FavouritesShowsListService()

    public static var shared = Resolver()
    
    func getTVShowTableViewDataSourceWithName(name: String) -> TVShowTableViewControllerDataSource{
        if name.elementsEqual("Favourites") {
            return favouritesShowsListService
        }else{
            return allShowListService
        }
        
    }

    func getTVShowDetailDataSource() -> TVShowDetailViewControllerDataSource {
        return allShowListService
    }
    
}
