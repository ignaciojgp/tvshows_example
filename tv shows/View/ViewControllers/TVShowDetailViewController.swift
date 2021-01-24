//
//  TVShowDetailViewController.swift
//  tv shows
//
//  Created by Ignacio J Gonzalez Pérez on 23/01/21.
//

import UIKit

class TVShowDetailViewController: UITableViewController {
    
    var tvShowInfo:RemoteTVShow?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false

        self.title = tvShowInfo?.name
        

        guard let data = tvShowInfo!.summary?.data(using: String.Encoding.utf8) else{
            return
        }
            
        
        let myAttribute = UIFont.systemFont(ofSize: 14)
        
            //[ NSFontAttributeName: UIFont(name: "Chalkduster", size: 18.0)! ]

        let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        
        attributedString?.addAttribute(.font, value: myAttribute, range: NSRange(location: 0,length: attributedString!.length))
        
        
        
        
        
        summaryLabel.attributedText = attributedString
        summaryLabel.adjustsFontSizeToFitWidth = true
        
//        Resolver.shared.remoteShowListService?.getImageWithUrl(urlString: tvShowInfo!.image.medium!  as NSString, onGetImage: { (image) in
//            
//            DispatchQueue.main.async {
//                self.posterImage.image = image
//            }
//            
//        })
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor.orange
//        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white // change the navigation background color
    }
    
    

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
