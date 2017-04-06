//
//  YADMusicManager.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation

class YADMusicManager
{
    
    class func getSongs(withLimit limit: Int, offset: Int, success: @escaping (NSArray) -> Void, failure: @escaping (Int) -> Void)
    {
        let operation = YADMusicOperation(withLimit: limit, offset: offset, success: success, failure: failure)
        YADOperationManager.addBusinessLogicOperation(op: operation, cancellingQueue: true)
    }
}
