//
//  YADPhotoLinkGetOperation.swift
//  YandexDisk
//
//  Created by Gregory House on 28.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation
import SwiftyJSON

class YADPhotoLinkGetOperation: Operation
{
    var path: String
    var success: (String) -> Void
    var failure: (Int) -> Void
    
    var internetTask: URLSessionDataTask?
    
    init(withPhotoModel path: String, success: @escaping (String) -> Void, failure: @escaping (Int) -> Void)
    {
        self.path = path
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
        
        internetTask = YADGlobalAPI_WRAPPER.getDownloadLink(withPath: path, successBlock: { (jsonResponse) in
            
            let fullSizeURL = jsonResponse["href"].stringValue
            if ( self.isCancelled != true )
            {
                self.success(fullSizeURL)
            }
            else
            {
                self.success("empty")
            }
            
            semaphore.signal()
            
        }, failureBlock: { (errorCode) in
            
            self.failure(errorCode)
            semaphore.signal()
            
        })
        
        _ = semaphore.wait(timeout: .distantFuture)
    }
}
