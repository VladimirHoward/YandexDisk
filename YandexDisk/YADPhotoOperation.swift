//
//  YADPhotoOperation.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation
import SwiftyJSON

class YADPhotoOperation: Operation
{
    var limit: Int
    var offset: Int
    var success: (NSArray, Int) -> Void
    var failure: (Int) -> Void
    
    var internetTask: URLSessionDataTask?
    
    init (withLimit limit: Int, offset: Int, success: @escaping (NSArray, Int) -> Void, failure: @escaping (Int) -> Void)
    {
        self.limit = limit
        self.offset = offset
        self.success = success
        self.failure = failure
    }
    
    override func cancel()
    {
        internetTask?.cancel()
    }
    
    override func main()
    {
        let semaphore = DispatchSemaphore(value: 0)
        
        internetTask = YADGlobalAPI_WRAPPER.getFileList(withLimit: limit, offset: offset, mediaType: YADConst.URLConst.Arguments.kImageType as String, successBlock: { (jsonResponse) in
            
            let outArray = NSMutableArray()
            let photos = jsonResponse["items"].arrayValue
            let jsonOffset = jsonResponse["offset"].intValue
            
            for photo in photos
            {
                let resourceID = photo["resource_id"].stringValue
                let name = photo["name"].stringValue
                let path = photo["path"].stringValue
                let previewURL = photo["preview"].stringValue
                let created = photo["created"].stringValue
                var fullSizeURL = ""
                
                self.internetTask = YADGlobalAPI_WRAPPER.getDownloadLink(withPath: path, successBlock: { (jsonResponse) in
                    
                    fullSizeURL = jsonResponse["href"].stringValue
                    
                    
                    
                }, failureBlock: self.failure)
                
                let localPhotoModel = YADPhotoModel(withResourceID: resourceID, name: name, path: path, previewURL: previewURL, fullSizeURL: fullSizeURL, created: created)
                outArray.add(localPhotoModel)

            }
            
            if (self.isCancelled != true)
            {
                print("количество моделей в массиве после парсинга в Операции - \(outArray.count)")
                self.success(outArray, jsonOffset)
            }
            else
            {
                self.success(NSArray(), jsonOffset)
            }
            
            semaphore.signal()
            
        }, failureBlock: { (errorCode) in
            
            self.failure(errorCode)
            semaphore.signal()
            
        })
    }
}
