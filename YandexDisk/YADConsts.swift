//
//  YADConsts.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import Foundation

class YADConst
{
    static let kBaseURL = "https://cloud-api.yandex.net:443/v1/disk"
    static let kLoginURL = "https://oauth.yandex.ru/authorize?response_type=token&display=popup&client_id=4c3afe7da61b45b9b7f4c1e40bf15efd"
    
    class Scripts
    {
        //запрос плоского списка файлов на диске
        //передать limit, offset, media_type
        static let kMethodFilesListGet = "/resources/files"
        
        //запрос ссылки на скачивание по path
        //передать path из объекта файла
        static let kMethodDownloadLinkGet = "/resources/download"
        
        //загрузка файлов на диск
        //передать path (disk:/*путь до желаемой папки*/*ИМЯ НОВОГО ФАЙЛА*), URL (локальный на устройстве), возвращает href, который содержит id операции
        static let kMethodFileUpload = "/resources/upload"
        
        //запрос статуса операции по загрузке
        //передать operation_id
        static let kMethodOperationStatus = "/operations/"
    }
    
    class URLConst
    {
        class Arguments
        {
            static let kLimit: NSString = "limit"
            static let kOffset: NSString = "offset"
            static let kMediaType: NSString = "media_type"
            static let kSort: NSString = "sort"
            static let kPath: NSString = "path"
            static let kUploadURL: NSString = "url"
            static let kResponseType: NSString = "response_type"
            static let kClientID: NSString = "client_id"
            static let kImageType: NSString = "image"
        }
    }
    
    class UIConsts
    {
        static let kLoginTabbarSegueIdentifier = "kLoginTabbarSegueIdentifier"
        static let kLoginScreenIdentifier = "kLoginScreenIdentifier"
        static let kTabbarScreenIdentifier = "kTabbarScreenIdentifier"
    }
    
    
}
