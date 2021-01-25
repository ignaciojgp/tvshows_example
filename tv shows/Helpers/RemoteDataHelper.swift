//
//  APIServiceImpl.swift
//  tv shows
//
//  Created by Ignacio J Gonzalez Pérez on 23/01/21.
//

import UIKit




public class RemoteDataHelper: NSObject {
    
    final let  TVSHOWS_URL = "http://api.tvmaze.com/shows"
    
    let decoder = JSONDecoder()
    let imageCache = NSCache<NSString, UIImage>()
    lazy var defaultimage:UIImage? = { return UIImage(named: "ExamplePoster") }()
    
    lazy var customURLSession:URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5.0
        sessionConfig.timeoutIntervalForResource = 5.0
        let session = URLSession(configuration: sessionConfig)
        return session
    }()
    
    
    func getImageWithUrl(urlString: NSString, onGetImage: @escaping  (UIImage?) -> Void) {
        
        if let image = imageCache.object(forKey: urlString){
            onGetImage(image);
        }else{
            let url = URL(string: urlString as String)!

            let task = customURLSession.dataTask(with: url) { [weak self]
                (data, response, error) in
                guard let data = data else { onGetImage(self?.defaultimage); return }
                guard let image = UIImage(data: data) else { onGetImage(self?.defaultimage); return }
                onGetImage(image)
            }
            
            task.resume()

        }
        
    }

    public func getShowsList(onresult: @escaping (Array<RemoteTVShow>?, Error?)->Void) {
        
        let url = URL(string: TVSHOWS_URL)!

        let task = customURLSession.dataTask(with: url) {
            (data, response, error) in
            
            if(error != nil){
                onresult(nil, error)
                return
            }
            
            guard let data = data else { return }
            
            
            do{
                let list = try self.decoder.decode(Array<RemoteTVShow>.self, from: data)
                onresult(list, nil)

            }catch{
                onresult(nil, error)
            }
        }

        task.resume()
                
    }

}
