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
}
