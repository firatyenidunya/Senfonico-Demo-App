//
//  Flickr.swift
//  Senfonico Flickr Demo
//
//  Created by Firat on 15.04.2018.
//  Copyright © 2018 resoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class Flickr{
    var id: String?
    var owner: String?
    var title: String?
    var server: String?
    var secret: String?
    
    init(json: JSON?){
        if let j = json{
            server = j["server"].stringValue
            id = j["id"].stringValue
            secret = j["secret"].stringValue
            owner = j["owner"].stringValue
            title = j["title"].stringValue
        }
        return
    }
}

extension Flickr{
    static func photos(json:JSON?) -> [Flickr]!{
        var flickr = [Flickr]()
        if let j = json{
            let jsonArray = j["photos"]["photo"].arrayValue
            for photoJson in jsonArray{
                flickr.append(Flickr(json:photoJson))
            }
        }
        return flickr
    }
}
