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
    class func currentTokenInMainContext () -> YADToken?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "YADToken")
        let fetchResults = try? YADCoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest) as! [YADToken]
        
        if ( fetchResults!.count == 1 )
        {
            let token = fetchResults![0]
            return token
        }
        
        return nil
    }
    
}
