//
//  YADMusicAPI_WRAPPER.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation
import SwiftyJSON

class YADMusicAPI_WRAPPER: YADGlobalAPI_WRAPPER
{
    
    class func getMusicList (withLimit limit: Int, offset: Int, mediaType: String, sort: String, successBlock: @escaping (_ jsonResponse: JSON) -> Void, failureBlock: @escaping (_ errorCode: Int) -> Void) -> URLSessionDataTask
    {
    
        let agrsDictionary = NSMutableDictionary()
        
        agrsDictionary.setObject("\(limit)", forKey: YADConst.URLConst.Arguments.kLimit)
        agrsDictionary.setObject("\(offset)", forKey: YADConst.URLConst.Arguments.kOffset)
        agrsDictionary.setObject(mediaType, forKey: YADConst.URLConst.Arguments.kMediaType)
        agrsDictionary.setObject(sort, forKey: YADConst.URLConst.Arguments.kSort)
        
        let request = composeGenericHTTPGetRequest(forBaseURL: YADConst.kBaseURL, andMethod: YADConst.Scripts.kMethodFilesListGet, withParameters: agrsDictionary)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            genericCompletetionCallback(withResponseData: data, response: response, error: error, successBlock: successBlock, failureBlock: failureBlock)
        }
        
        task.resume()
        return task
    }
    
}
