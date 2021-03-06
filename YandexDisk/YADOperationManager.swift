//
//  YADOperationManager.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation

class YADOperationManager
{
    private static let businessLogicOperationQueue = OperationQueue()
    
    class func addBusinessLogicOperation (op: Operation, cancellingQueue flag: Bool)
    {
        businessLogicOperationQueue.maxConcurrentOperationCount = 1
        
        if flag
        {
            businessLogicOperationQueue.cancelAllOperations()
        }
        
        businessLogicOperationQueue.addOperation(op)
    }
}
