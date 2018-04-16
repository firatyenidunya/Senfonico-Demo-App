//
//  FlickrCell.swift
//  Senfonico Flickr Demo
//
//  Created by Firat on 15.04.2018.
//  Copyright © 2018 resoft. All rights reserved.
//

import UIKit

class FlickrCell: UITableViewCell {
    @IBOutlet var flickrImage: UIImageView!
    @IBOutlet var owner: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.borderColor = UIColor.black.cgColor
        mainView.layer.borderWidth = 0.2
    }    
}
