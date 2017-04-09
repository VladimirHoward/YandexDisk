//
//  YADMusicGetLinkOperation.swift
//  YandexDisk
//
//  Created by Gregory House on 06.04.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation
import SwiftyJSON

class YADMusicGetLinkOperation: Operation
{
    var path: String
    var success: (String) -> Void
    var failure: (Int) -> Void
    
    var interneTask: URLSessionDataTask?
    
    init (withMusicPath path: String, success: @escaping (String) -> Void, failure: @escaping (Int) -> Void)
    {
        self.path = path
        self.success = success
        self.failure = failure
    }
    
    override func cancel()
    {
        interneTask?.cancel()
    }
    
    override func main()
    {
        let semaphore = DispatchSemaphore(value: 0)
        
        interneTask = YADGlobalAPI_WRAPPER.getDownloadLink(withPath: path, successBlock: { (jsonResponse) in
            
            let audioURL = jsonResponse["href"].stringValue
            if (self.isCancelled != true)
            {
                self.success(audioURL)
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
