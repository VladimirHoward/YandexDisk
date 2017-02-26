//
//  YADGlobalAPI_WRAPPER.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation
import SwiftyJSON

class YADGlobalAPI_WRAPPER
{
    class func composeGenericHTTPGetRequest (forBaseURL baseURL: String, andMethod method: String, withParameters parameters: NSDictionary) -> NSURLRequest
    {
        var requestString = baseURL + method + "?"
        
        let keysArray = parameters.allKeys as! [String]
        
        for i in 0..<keysArray.count
        {
            let key = keysArray[i]
            let value = parameters[key] as! String
            
            if (i < keysArray.count - 1)
            {
                requestString += "\(key)=\(value)&"
            }
            else
            {
                requestString += "\(key)=\(value)"
            }
        }
        
        print("строка запроса - \(requestString)")
        
        let request = NSMutableURLRequest ()
        request.httpMethod = "GET"
        request.setValue("OAuth " + YADLoginManager.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
        request.url = URL(string: requestString)
        
        return request
    }
    
    class func composeGenericHTTPPostRequest (forBaseURL baseURL: String, andMethod method: String, withParameters parameters: NSDictionary) -> NSURLRequest
    {
        var requestString = baseURL + method + "?"
        
        let keysArray = parameters.allKeys as! [String]
        
        for i in 0..<keysArray.count
        {
            let key = keysArray[i]
            let value = parameters[key] as! String
            
            if (i < keysArray.count - 1)
            {
                requestString += "\(key)=\(value)&"
            }
            else
            {
                requestString += "\(key)=\(value)"
            }
        }
        
        print("строка запроса - \(requestString)")
        
        let request = NSMutableURLRequest ()
        request.httpMethod = "POST"
        request.setValue("OAuth " + YADLoginManager.sharedInstance.getToken(), forHTTPHeaderField: "Authorization")
        request.url = URL(string: requestString)
        
        return request
    }
}

//MARK: получение списка файлов заданного типа
extension YADGlobalAPI_WRAPPER
{
    class func getFileList (withLimit limit: Int, offset: Int, mediaType: String, successBlock: @escaping (_ jsonResponse: JSON) -> Void, failureBlock: @escaping (_ errorCode: Int) -> Void) -> URLSessionDataTask
    {
        let agrsDictionary = NSMutableDictionary ()
        
        agrsDictionary.setObject("\(limit)", forKey: YADConst.URLConst.Arguments.kLimit)
        agrsDictionary.setObject("\(offset)", forKey: YADConst.URLConst.Arguments.kOffset)
        agrsDictionary.setObject("\(mediaType)", forKey: YADConst.URLConst.Arguments.kMediaType)
        
        let request = composeGenericHTTPGetRequest(forBaseURL: YADConst.kBaseURL, andMethod: YADConst.Scripts.kMethodFilesListGet, withParameters: agrsDictionary)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            genericCompletetionCallback(withResponseData: data, response: response, error: error, successBlock: successBlock, failureBlock: failureBlock)
        }
        
        task.resume()
        return task
    }
}

//MARK: получение ссылки на скачивание файла
extension YADGlobalAPI_WRAPPER
{
    class func getDownloadLink (withPath path: String, successBlock: @escaping (_ jsonResponse: JSON) -> Void, failureBlock: @escaping (_ errorCode: Int) -> Void) -> URLSessionDataTask
    {
        let agrsDictionary = NSMutableDictionary ()
        
        agrsDictionary.setObject("\(path)", forKey: YADConst.URLConst.Arguments.kPath)
        
        let request = composeGenericHTTPGetRequest(forBaseURL: YADConst.kBaseURL, andMethod: YADConst.Scripts.kMethodDownloadLinkGet, withParameters: agrsDictionary)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            genericCompletetionCallback(withResponseData: data, response: response, error: error, successBlock: successBlock, failureBlock: failureBlock)
        }
        
        task.resume()
        return task
    }
}

//MARK: загрузка файлов на диск
extension YADGlobalAPI_WRAPPER
{
    class func postUploadFile (withPath path: String, andURL url: String, successBlock: @escaping (_ jsonResponse: JSON) -> Void, failureBlock: @escaping (_ errorCode: Int) -> Void) -> URLSessionDataTask
    {
        let agrsDictionary = NSMutableDictionary ()
        
        agrsDictionary.setObject("\(path)", forKey: YADConst.URLConst.Arguments.kPath)
        agrsDictionary.setObject("\(url)", forKey: YADConst.URLConst.Arguments.kUploadURL)
        
        let request = composeGenericHTTPPostRequest(forBaseURL: YADConst.kBaseURL, andMethod: YADConst.Scripts.kMethodFileUpload, withParameters: agrsDictionary)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            genericCompletetionCallback(withResponseData: data, response: response, error: error, successBlock: successBlock, failureBlock: failureBlock)
        }
        
        task.resume()
        return task
    }
}

//MARK: получение информации о статусе загрузки файла на диск
extension YADGlobalAPI_WRAPPER
{
    class func getDownloadStatus (withOperationID opID: String, successBlock: @escaping (_ jsonResponse: JSON) -> Void, failureBlock: @escaping (_ errorCode: Int) -> Void) -> URLSessionDataTask
    {
        
        let requestString = YADConst.kBaseURL + YADConst.Scripts.kMethodOperationStatus + "\(opID)"
        
        let request = NSMutableURLRequest ()
        request.httpMethod = "GET"
        request.url = URL(string: requestString)
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            genericCompletetionCallback(withResponseData: data, response: response, error: error, successBlock: successBlock, failureBlock: failureBlock)
        }
        
        task.resume()
        return task
    }
}
//MARK: общий обработчик ответов для JSON
extension YADGlobalAPI_WRAPPER
{
    class func genericCompletetionCallback (withResponseData data: Data?, response: URLResponse?, error: Error?, successBlock: (_ jsonResponse: JSON) -> Void, failureBlock: (_ errorCode: Int) -> Void)
    {
        if (error != nil)
        {
            failureBlock((error as! NSError).code)
        }
        
        if (data != nil)
        {
            do
            {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let swiftyJSON = JSON(json)
                print("ответ - \(swiftyJSON)")
                successBlock(swiftyJSON)
            }
            catch
            {
                failureBlock(-80)
            }
        }
        else
        {
            failureBlock(-80)
        }
    }
}










