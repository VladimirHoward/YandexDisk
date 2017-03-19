//
//  YADPhotoUploadOperation.swift
//  YandexDisk
//
//  Created by Gregory House on 16.03.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation
import SwiftyJSON

class YADPhotoUploadOperation: Operation
{
    var path: String
    var url: String
    var success: (String) -> Void
    var failure: (Int) -> Void
    
    var internetTask: URLSessionDataTask?
    
    init(withName path: String, url: String, success: @escaping (String) -> Void, failure: @escaping (Int) -> Void)
    {
        self.path = path
        self.url = url
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
        
        internetTask = YADPhotoAPI_WRAPPER.photoUploadHref(withPath: path, andURL: url, successBlock: { (jsonResnopse) in
            
            print("with url - \(self.url)")
            let uploadHref = jsonResnopse["href"].stringValue
                
            if (self.isCancelled != true)
            {
                self.success(uploadHref)
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
