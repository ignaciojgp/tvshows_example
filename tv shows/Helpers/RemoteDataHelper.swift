//
//  APIServiceImpl.swift
//  tv shows
//
//  Created by Ignacio J Gonzalez Pérez on 23/01/21.
//

import UIKit
import Alamofire




public class RemoteDataHelper: NSObject {
    let decoder = JSONDecoder()
    let imageCache = NSCache<NSString, UIImage>()
    lazy var defaultimage:UIImage? = { return UIImage(named: "ExamplePoster") }()
    
    
    func getImageWithUrl(urlString: NSString, onGetImage: @escaping  (UIImage?) -> Void) {
        
        if let image = imageCache.object(forKey: urlString){
            onGetImage(image);
        }else{
            let url = URL(string: urlString as String)!

            let task = URLSession.shared.dataTask(with: url) { [weak self]
                (data, response, error) in
                guard let data = data else { onGetImage(self?.defaultimage); return }
                guard let image = UIImage(data: data) else { onGetImage(self?.defaultimage); return }
                onGetImage(image)
            }
            
            task.resume()

        }
        
    }

    public func getShowsList(onresult: @escaping (Array<RemoteTVShow>?, Error?)->Void) {
        
        let url = URL(string: "http://api.tvmaze.com/shows")!

        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            guard let data = data else { return }
            let resultString =  String(data: data, encoding: .utf8)
            
            debugPrint(resultString ?? "null result");
            
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
