//
//  ShowListService.swift
//  tv shows
//
//  Created by Ignacio J Gonzalez Pérez on 24/01/21.
//

import UIKit



public class ShowListService:NSObject, TVShowTableViewControllerDataSource, TVShowDetailViewControllerDataSource {
    
    func shouldShowAsFavourite(id: Int64) -> Bool {
        return Resolver.shared.localDataHelper.getEntity(name: .tvShow, by: id) != nil
    }
    
    func getShowsList(onresult: @escaping (Array<RemoteTVShow>?, Error?) -> Void) {
        fatalError("Subclasses need to implement the `getShowsList()` method.")
    }
    
    func getImageWithUrl(urlString: NSString, onGetImage: @escaping (UIImage?) -> Void) {
        Resolver.shared.remoteDataHelper.getImageWithUrl(urlString: urlString, onGetImage: onGetImage)
    }
    
    
    func changeFavouriteState(tvShow: RemoteTVShow) {
        
        if Resolver.shared.localDataHelper.getEntity(name: .tvShow, by: tvShow.id) != nil {
            let num = Resolver.shared.localDataHelper.deleteEntity(name: .tvShow, by: tvShow.id)
            print("deleted \(String(describing: num)) tvshows")
        }else{
            let entity = Resolver.shared.localDataHelper.createObject(name: .tvShow) as! FavoriteTVShow

            entity.id = tvShow.id
            entity.name = tvShow.name
            entity.image = tvShow.image.medium
            entity.summary = tvShow.summary
            entity.imdb = tvShow.externals.imdb

        }
        
        do{
            try Resolver.shared.localDataHelper.save()
        }catch{
            debugPrint(error)
        }

    }
    
}


public class AllShowListService: ShowListService {
    
    var chachedList:Array<RemoteTVShow>?
    
    override func getShowsList(onresult: @escaping (Array<RemoteTVShow>?, Error?) -> Void) {
        
        if(chachedList == nil){
            Resolver.shared.remoteDataHelper.getShowsList { (list, error) in
                
                
                let sorted  = list?.sorted(by: { (a, b) -> Bool in
                    guard let aname = a.name else {return false}
                    guard let bname = b.name else {return false}
                    return aname.localizedStandardCompare(bname) == .orderedAscending
                })
                
                self.chachedList = sorted
                onresult(sorted, error)
            }
        }else{
            onresult(chachedList, nil)
        }
    }
    
    
}

public class FavouritesShowsListService: ShowListService {
    
    
    override func getShowsList(onresult: @escaping (Array<RemoteTVShow>?, Error?) -> Void) {
        let list = Resolver.shared.localDataHelper.getEntityList(name: .tvShow)
        
        var parsedlist = Array<RemoteTVShow>()
        
        list?.forEach({ (favouriteTVShow) in
            
            guard let fav = favouriteTVShow as? FavoriteTVShow else {return}
            
            let remoteTVShow = RemoteTVShow(
                id: fav.id,
                name: fav.name,
                summary: fav.summary,
                image: Image(
                    medium: fav.image,
                    original: nil),
                externals: Externals(
                    tvrage: 0,
                    thetvdb: 0,
                    imdb: fav.imdb)
            )
            
            parsedlist.append(remoteTVShow)
            
            
        })
        
        onresult(parsedlist, nil)
        
    }
    
   
}
