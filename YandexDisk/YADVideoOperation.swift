//
//  YADVideoOperation.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation

class YADVideoOperation: Operation
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
        
        internetTask = YADGlobalAPI_WRAPPER.getFileList(withLimit: limit, offset: offset, mediaType: YADConst.URLConst.Arguments.kVideoType as String, successBlock: { (jsonResponse) in
            
            let outArray = NSMutableArray()
            let videos = jsonResponse["items"].arrayValue
            let jsonOffset = jsonResponse["offset"].intValue
            
            for video in videos
            {
                
                let resourceID = video["resource_id"].stringValue
                let name = video["name"].stringValue
                let path = video["path"].stringValue
                let previewURL = video["preview"].stringValue
                let created = video["created"].stringValue
                var fullSizeURL = ""
                
                self.internetTask = YADGlobalAPI_WRAPPER.getDownloadLink(withPath: path, successBlock: { (jsonResponse) in
                    
                    fullSizeURL = jsonResponse["href"].stringValue
                    
                    
                    
                }, failureBlock: self.failure)
                
                let localPhotoModel = YADVideoModel(withResourceID: resourceID, name: name, path: path, previewURL: previewURL, fullSizeURL: fullSizeURL, created: created)
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
