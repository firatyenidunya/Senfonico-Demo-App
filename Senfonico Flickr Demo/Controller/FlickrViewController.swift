//
//  ViewController.swift
//  Senfonico Flickr Demo
//
//  Created by Firat on 14.04.2018.
//  Copyright © 2018 resoft. All rights reserved.
//

import UIKit
import SDWebImage
import SKPhotoBrowser

class FlickrViewController: UIViewController {
    @IBOutlet var flickrTableView: UITableView!
    
    var flickr: [Flickr]?
    var basePhotoAddress = "https://c1.staticflickr.com/1/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPhotosFromFlickr()
        setupSettingCellXib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        flickrTableView.rowHeight = UITableViewAutomaticDimension
        flickrTableView.estimatedRowHeight = 306
    }
    
    func getPhotosFromFlickr(){
        let apiKey = "YOUR_FLICKR_API_KEY"
        ServiceConnector.shared.connect(.getRecentPhotos(apiKey: apiKey, format: "json", noJsonCallback: "1")){(target, response) in
            let status = response["stat"].stringValue
            switch status{
            case "ok":
                self.flickr = Flickr.photos(json: response)
                self.flickrTableView.reloadData()
            case "fail":
                print(response["message"].stringValue)
            default:
                print("Something went wrong")
            }
        }
    }
    
    func setupSettingCellXib() {
        flickrTableView.register(UINib(nibName: "FlickrCell", bundle: nil), forCellReuseIdentifier: "FlickrCell")
    }
}

extension FlickrViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _flickr = self.flickr, !_flickr.isEmpty{
            return _flickr.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrCell", for: indexPath) as! FlickrCell
        if let _flickr = self.flickr, !_flickr.isEmpty{
            
            let flickr = _flickr[indexPath.row]
            
            cell.title.text = flickr.title
            cell.owner.text = flickr.owner
            cell.flickrImage.sd_setImage(with: URL(string: self.basePhotoAddress+flickr.server!+"/"+flickr.id!+"_"+flickr.secret!+".jpg"))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let _flickr = self.flickr, !_flickr.isEmpty{
            
            let flickr = _flickr[indexPath.row]

            var images = [SKPhoto]()
            let photo = SKPhoto.photoWithImageURL(self.basePhotoAddress+flickr.server!+"/"+flickr.id!+"_"+flickr.secret!+".jpg")
            photo.shouldCachePhotoURLImage = false
            images.append(photo)
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(0)
            present(browser, animated: true, completion: {})
        }
    }
}
