//
//  APIServiceImpl.swift
//  tv shows
//
//  Created by Ignacio J Gonzalez Pérez on 23/01/21.
//

import UIKit
import Alamofire

public class RemoteDataHelper: NSObject, ShowsListService {
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


public class MockRemoteDataServiceImpl: NSObject, ShowsListService {
    
    lazy var defaultimage:UIImage? = { return UIImage(named: "ExamplePoster") }()

    
    func getImageWithUrl(urlString: NSString, onGetImage: @escaping  (UIImage?) -> Void) {

        DispatchQueue.global().asyncAfter(deadline: .now()+0.5) {
            onGetImage(self.defaultimage)

        }
    }
    
    
    public func getShowsList(onresult: @escaping (Array<RemoteTVShow>?, Error?)->Void) {
        
        let mock = "{ \"id\": 234, \"url\": \"http://www.tvmaze.com/shows/234/missing\", \"name\": \"Missing\", \"type\": \"Scripted\", \"language\": \"English\", \"genres\": [ \"Drama\", \"Action\", \"Thriller\" ], \"status\": \"Ended\", \"runtime\": 60, \"premiered\": \"2012-03-15\", \"officialSite\": null, \"schedule\": { \"time\": \"20:00\", \"days\": [ \"Thursday\" ] }, \"rating\": { \"average\": 6.7 }, \"weight\": 0, \"network\": { \"id\": 3, \"name\": \"ABC\", \"country\": { \"name\": \"United States\", \"code\": \"US\", \"timezone\": \"America/New_York\" } }, \"webChannel\": null, \"externals\": { \"tvrage\": 28396, \"thetvdb\": 248797, \"imdb\": \"tt1828246\" }, \"image\": { \"medium\": \"http://static.tvmaze.com/uploads/images/medium_portrait/1/3808.jpg\", \"original\": \"http://static.tvmaze.com/uploads/images/original_untouched/1/3808.jpg\" }, \"summary\": \"<p>Becca Winstone learns that her son, Michael, disappears while studying abroad, and it's a race against time when she travels to Europe to track him down. A surprising turn of events reveals just how far one mother will go to protect her family. Exotic locations and thrilling twists will keep you riveted in <b>Missing</b>. How far would you go to save the only thing you have left in the world? At 8 years old, Michael watched as his father, CIA Agent Paul Winstone, was murdered. Now 10 years later, Paul's wife, Becca, is faced with the reality of her son growing up. When Michael is afforded the opportunity to study abroad, his mother reluctantly agrees it's time to let him go. Just a few weeks into his trip Michael disappears, and Becca immediately suspects foul play. When she arrives in Rome, she begins piecing together the clues left behind. It isn't long before the kidnappers realize they've picked a fight with the wrong woman. Becca Winstone has a secret of her own -- before Paul's death, she was also a lethal CIA Agent. But if she wants to find her son alive, Becca will have to rely on old friends and reopen old wounds. Her resourcefulness, skill and determination will be put to the test - but a mother's love knows no limits.</p>\", \"updated\": 1575110923, \"_links\": { \"self\": { \"href\": \"http://api.tvmaze.com/shows/234\" }, \"previousepisode\": { \"href\": \"http://api.tvmaze.com/episodes/14667\" } } }"
        
        let decoder = JSONDecoder()
        
        
        guard let data = mock.data(using: String.Encoding.utf8) else {
            return
        }
        
        do {
            let show = try decoder.decode(RemoteTVShow.self, from: data)
            
            debugPrint(show)
            
            onresult([show], nil)

        } catch {
            print("error decoding")
            onresult(nil, nil)
        }
        
        
    }

}



