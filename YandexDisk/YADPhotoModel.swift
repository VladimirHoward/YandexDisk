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
    
//    var underlyingImage: UIImage? = nil
//    
//    func loadUnderlyingImageAndNotify()
//    {
//        SDWebImageManager.shared().downloadImage(with: URL(string: fullSizeURL)!, options: .retryFailed, progress: nil) { (image, error, cacheType, cached, url) in
//            
//            if (image != nil)
//            {
//                self.underlyingImage = image
//                self.reportImageLoaded()
//            }
//        }
//    }
//    
//    func performLoadUnderlyingImageAndNotify()
//    {
//        
//    }
//    
//    func unloadUnderlyingImage()
//    {
//        underlyingImage = nil
//    }
//    
//    private func reportImageLoaded ()
//    {
//        DispatchQueue.main.async {
//            
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MWPHOTO_LOADING_DID_END_NOTIFICATION"), object: self)
//            
//        }
//    }
}
