//
//  YADPhotoModel.swift
//  YandexDisk
//
//  Created by Gregory House on 26.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation
import MWPhotoBrowser
import SDWebImage

class YADPhotoModel: NSObject
{
    var name: String
    var resourceID: String
    var path: String
    var previewURL: String
    var fullSizeURL: String
    var created: String
    
    init(withResourceID resourceID: String, name: String, path: String, previewURL: String, fullSizeURL: String, created: String)
    {
        self.name = name
        self.resourceID = resourceID
        self.path = path
        self.previewURL = previewURL
        self.fullSizeURL = fullSizeURL
        self.created = created
    }
}
