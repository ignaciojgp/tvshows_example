//
//  TVShowDetailViewController.swift
//  tv shows
//
//  Created by Ignacio J Gonzalez Pérez on 23/01/21.
//

import UIKit

protocol TVShowDetailViewControllerDataSource{
    func getImageWithUrl(urlString:NSString, onGetImage: @escaping (UIImage?)->Void)
    func shouldShowAsFavourite(id:Int64) ->Bool
    func changeFavouriteState(tvShow: RemoteTVShow)-> Void

}

class TVShowDetailViewController: UITableViewController {
    
    var tvShowInfo:RemoteTVShow?
    var datasource:TVShowDetailViewControllerDataSource?
    
    
    @IBOutlet weak var fabButton: UIBarButtonItem!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var IMBDLink: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        
        datasource = Resolver.shared.getTVShowDetailDataSource()
        
        initView()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor.orange
        //        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white // change the navigation background color
        
        self.datasource?.getImageWithUrl(urlString: tvShowInfo!.image.medium! as NSString, onGetImage: { (image) in
            DispatchQueue.main.async {
                self.posterImage.image = image
            }
        })
        
    }
    
    
    func initView(){
        
        self.title = tvShowInfo?.name
        
        
        guard let data = tvShowInfo!.summary?.data(using: String.Encoding.utf8) else{
            return
        }
        let myAttribute = UIFont.systemFont(ofSize: 14)
        let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        
        attributedString?.addAttribute(.font, value: myAttribute, range: NSRange(location: 0,length: attributedString!.length))
        summaryLabel.attributedText = attributedString
        summaryLabel.adjustsFontSizeToFitWidth = true
        
        
        updateFabButton()
        
        
        if (self.tvShowInfo?.externals.imdb) == nil {
            self.IMBDLink.isHidden = true
        }
    }
    
    func updateFabButton(){
        
        self.navigationItem.rightBarButtonItem = nil
        var image:UIImage
        
        guard let datasource = self.datasource else { return}

        if datasource.shouldShowAsFavourite(id: self.tvShowInfo!.id) {
            image = UIImage(systemName: "star.fill")!
        }else{
            image = UIImage(systemName: "star")!
        }
        
        
        let newButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(onFabButton))

        self.navigationItem.rightBarButtonItem = newButton
        
    }
    
    
    @IBAction func onFabButton(_ sender: Any) {
        
        guard let datasource = self.datasource else { return}

        if datasource.shouldShowAsFavourite(id: self.tvShowInfo!.id) {
            removeFromFabourites()
        }else{
            self.datasource?.changeFavouriteState(tvShow: self.tvShowInfo!)
            updateFabButton()
        }
        
    }
    
    @IBAction func onTapIMDB(_ sender: Any) {
        
        if let imdb = self.tvShowInfo?.externals.imdb{
            BrowserHelper.openIMDB(id: imdb)

        }
        
    }
    
    func removeFromFabourites(){
        let alert = UIAlertController(title: "Wait", message: "Are you sure to delete this favourite?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.datasource?.changeFavouriteState(tvShow: self.tvShowInfo!)
            self.updateFabButton()

        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            print("delete canceled")
        }))
        
        self.present(alert, animated: true) {
            
        }
    }
    
    
    
}
