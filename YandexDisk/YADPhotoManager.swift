//
//  YADPhotoManager.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation

class YADPhotoManager
{
    class func getPhotos (limit: Int, offset: Int, success: @escaping (NSArray, Int) -> Void, failure: @escaping (Int) -> Void)
    {
        let operation = YADPhotoOperation(withLimit: limit, offset: offset, success: success, failure: failure)
        YADOperationManager.addBusinessLogicOperation(op: operation, cancellingQueue: true)
    }
    
    class func uploadPhoto (withName path: String, url: String, success: @escaping (String) -> Void, failure: @escaping (Int) -> Void)
    {
        let operation = YADPhotoUploadOperation(withName: path, url: url, success: success, failure: failure)
        YADOperationManager.addBusinessLogicOperation(op: operation, cancellingQueue: true)
    }
    
    class func getLink (withPath path: String, success: @escaping (String) -> Void, failure: @escaping (Int) -> Void)
    {
        let operation = YADPhotoLinkGetOperation(withPhotoModel: path, success: success, failure: failure)
        YADOperationManager.addServiceOperation(op: operation , cancellingQueue: true)
    }
}
