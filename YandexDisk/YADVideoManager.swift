//
//  YADVideoManager.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation

class YADVideoManager
{
    class func getVideos (limit: Int, offset: Int, success: @escaping (NSArray, Int) -> Void, failure: @escaping (Int) -> Void)
    {
        let operation = YADVideoOperation(withLimit: limit, offset: offset, success: success, failure: failure)
        YADOperationManager.addBusinessLogicOperation(op: operation, cancellingQueue: true)
    }
}
