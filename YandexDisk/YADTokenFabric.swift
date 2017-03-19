//
//  YADTokenFabric.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation
import CoreData

class YADTokenFabric
{
    
//    static let lock = NSNumber(value: 0.5)
    static var tempToken = ""
    //MARK: создание или обновление текущего токена для приложения
    class func createOrUpdateToken (withToken enterToken: String, context: NSManagedObjectContext) -> YADToken
    {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "YADToken")
        let predicate = NSPredicate(format: "token=%@", enterToken)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest) as! [YADToken]
        
        if (fetchResults!.count != 0)
        {
            let token = fetchResults![0]
            return token
        }
        else
        {
            let token = NSEntityDescription.insertNewObject(forEntityName: "YADToken", into: context) as! YADToken
            
            token.token = enterToken
            return token
        }
    }
    
    //MARK: получение текущего токена
    class func currentTokenInMainContext () -> String?
    {
//        objc_sync_enter(lock)
        if tempToken == ""
        {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "YADToken")
            let fetchResults = try? YADCoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest) as! [YADToken]
            
            if ( fetchResults!.count == 1 )
            {
                tempToken = fetchResults![0].token
                //            objc_sync_exit(lock)
                return tempToken
            }

        }
        else
        {
            return tempToken
        }
        
//        objc_sync_exit(lock)
        return nil
    }
    
}
