//
//  TVShowTableViewController.swift
//  tv shows
//
//  Created by Ignacio J Gonzalez Pérez on 23/01/21.
//

import UIKit


protocol TVShowTableViewControllerDataSource {
    func getShowsList(onresult:@escaping  (Array<RemoteTVShow>?, Error?)->Void)->Void
    func getImageWithUrl(urlString:NSString, onGetImage: @escaping (UIImage?)->Void)
    func shouldShowAsFavourite(id:Int64) ->Bool
    func changeFavouriteState(tvShow: RemoteTVShow)-> Void
}

class TVShowTableViewController: UITableViewController {
    
    final let CELL_NAME = "defaultcell"
    final let SEGUE_TO_DETAIL = "toDetail"
    

    var itemsList = Array<RemoteTVShow>()
    var dataSource: TVShowTableViewControllerDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = Resolver.shared.getTVShowTableViewDataSourceWithName(name: self.navigationItem.title ?? "")
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(red: 102/256, green: 31/256, blue: 254/256, alpha: 100)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        loadData()
    }

    func loadData(){
        dataSource?.getShowsList(onresult: { (list, error) in
            if(error == nil){
                self.itemsList = list!
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                    
                }
                
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_NAME, for: indexPath)

        let textLabel = cell.contentView.viewWithTag(1) as? UILabel
        let imageView = cell.contentView.viewWithTag(2) as? UIImageView
        
        textLabel?.text = self.itemsList[indexPath.row].name
        imageView?.image = nil
        imageView?.isHidden = true
        let cgSize = CGSize(width: imageView!.frame.width, height: imageView!.frame.height)

        
        dataSource?.getImageWithUrl(urlString: self.itemsList[indexPath.row].image.medium! as NSString, onGetImage: { (image) in
            
            
            guard let image = image else {return}
            let aspect =  image.size.height / image.size.width
            UIGraphicsBeginImageContextWithOptions(cgSize, true, 0.0)
            image.draw(in: CGRect(x: 0, y: 0, width: cgSize.width, height: cgSize.height*aspect ))
            let newImage = UIGraphicsGetImageFromCurrentImageContext();

            DispatchQueue.main.async {                
                imageView?.image = newImage
                imageView?.isHidden = false
            }
            
        })
        
        

        return cell
    }
    
    
    func changeFavouriteState(_ tvShow:RemoteTVShow){
        self.dataSource?.changeFavouriteState(tvShow: tvShow)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let tvShowInfo = self.itemsList[indexPath.row]

        guard let dataSource = dataSource else {return nil}
        
        let favourite = dataSource.shouldShowAsFavourite(id: tvShowInfo.id)
        
        let action = UIContextualAction(style: .normal, title: favourite ? "Delete":"Favourite" ) {
            [weak self] (action, view, completionHandler) in
            self?.changeFavouriteState(tvShowInfo)
            completionHandler(true)
        }
        action.backgroundColor = favourite ? .systemRed : .systemGreen
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier != nil && segue.identifier!.elementsEqual(SEGUE_TO_DETAIL)){
            guard let indexpath = self.tableView.indexPath(for: sender as! UITableViewCell)else{
                return
            }
            let tvShowInfo = self.itemsList[indexpath.row]
            
            guard let destination = segue.destination as? TVShowDetailViewController else{
                return
            }
            
            destination.tvShowInfo = tvShowInfo
            
            
        }
    }
    

}
