//
//  YADLoginManager.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import UIKit

class YADLoginManager: NSObject
{
    static let sharedInstance = YADLoginManager()
    
    var successBlock: ( () -> Void )?
    var failureBlock: ( () -> Void )?
    weak var webView : UIWebView?
}

//MARK: логин и авторизация
extension YADLoginManager
{
    func shouldLogin () -> Bool
    {
        return getToken() == ""
    }
    
    func login (withUnderlayController webView: UIWebView, success: @escaping () -> Void, failure: @escaping () -> Void)
    {
        self.webView = webView
        self.successBlock = success
        self.failureBlock = failure
        
        let request = NSURLRequest(url: NSURL(string: YADConst.kLoginURL) as! URL)
        webView.loadRequest(request as URLRequest)
        webView.delegate = self
//        print("3. Перенаправили блоки, послали запрос в космос, присвоили делегата webView")
    }
}

//MARK: процедуры UIWebViewDelegate
extension YADLoginManager: UIWebViewDelegate
{
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        if let requestURL = request.url
        {
            if requestURL.scheme == "yadapp"
            {
//                print("5. строка второго запроса - \(requestURL)")
                //                print("URL схема второго - \(requestURL.scheme)")
                
                let set = CharacterSet(charactersIn: "#=&")
                let arr = String(describing: requestURL).components(separatedBy: set)
                let token = arr[2]
//                print("токен - \(token)")
                
                setToken(withToken: token)
                print("7. все збс, всплываем во VC через successBlock")
                self.successBlock?()
                
                
                return false
            }
            
//            print("4. строка первого запроса - \(requestURL)")
            //            print("URL схема первого - \(requestURL.scheme)")
            
            return true
        }
        else
        {
            print("отсутствует строка запроса")
            failureBlock?()
            return false
        }
    }
    
    private func setToken(withToken token: String)
    {
        _ = YADTokenFabric.createOrUpdateToken(withToken: token, context: YADCoreDataManager.sharedInstance.managedObjectContext)
        YADCoreDataManager.sharedInstance.save()
//        print("6. заводим токен в кордате, сохраняем в контекст")
    }
    
}

//MARK: внешний доступ к токену
extension YADLoginManager
{
    func getToken () -> String
    {
        if let token = YADTokenFabric.currentTokenInMainContext()
        {
            return token.token
        }
        return ""
    }
}

