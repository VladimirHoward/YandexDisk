//
//  YADMusicOperation.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation
import SwiftyJSON

class YADMusicOperation: Operation
{
    var limit: Int
    var offset: Int
    var success: (NSArray) -> Void
    var failure: (Int) -> Void
    
    var internetTask: URLSessionDataTask?
    
    init(withLimit limit: Int, offset: Int, success: @escaping (NSArray) -> Void, failure: @escaping (Int) -> Void)
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
        
        internetTask = YADMusicAPI_WRAPPER.getMusicList(withLimit: limit, offset: offset, mediaType: YADConst.URLConst.Arguments.kMusicType as String, sort: YADConst.URLConst.Arguments.kSortByName as String, successBlock: { (jsonResponse) in
            
            let outArray = NSMutableArray()
            
            let songs = jsonResponse["items"].arrayValue
            
            for song in songs
            {
                let resourceId = song["resource_id"].stringValue
                let name = song["name"].stringValue
                let Tpath = song["path"].stringValue
                let created = song["created"].stringValue
                let audioURL = ""
                
                let localMusicModel = YADMusicModel(withResourseID: resourceId, name: name, path: Tpath, audioURL: audioURL, created: created)
                outArray.add(localMusicModel)
            }
            
            if (self.isCancelled != true)
            {
                self.success(outArray)
            }
            else
            {
                self.success(NSArray())
            }
            
            semaphore.signal()
            
        }, failureBlock: { (errorCode) in
            self.failure(errorCode)
            semaphore.signal()
        })
        
        _ = semaphore.wait(timeout: .distantFuture)
    }
}
