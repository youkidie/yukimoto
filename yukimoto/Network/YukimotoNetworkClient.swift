//
//  YukimotoNetworkClient.swift
//  yukimoto
//
//  Created by 雪本大樹 on 2017/11/06.
//  Copyright © 2017年 雪本大樹. All rights reserved.
//

import Foundation
import Alamofire

class YukimotoNetworkClient {
    static let sharedClient = YukimotoNetworkClient()
    
    var token:UserToken? = nil
    
    fileprivate init() {
    }
    
    func setToken(_ token:UserToken) {
        self.token = token
    }
    
    func get(_ path:String, params:Dictionary<String,String>?, onSuccess:((NSDictionary)->Void)?, onError:((DataResponse<Any>)->Void)?) {
        submit(.get, path:path, params:params, onSuccess:onSuccess, onError:onError);
    }
    
    func post(_ path:String, params:Dictionary<String,String>?, onSuccess:((NSDictionary)->Void)?, onError:((DataResponse<Any>)->Void)?) {
        submit(.post, path:path, params:params, onSuccess:onSuccess, onError:onError);
    }
    
    func put(_ path:String, params:Dictionary<String,String>?, onSuccess:((NSDictionary)->Void)?, onError:((DataResponse<Any>)->Void)?) {
        submit(.put, path:path, params:params, onSuccess:onSuccess, onError:onError);
    }
    
    func patch(_ path:String, params:Dictionary<String,String>?, onSuccess:((NSDictionary)->Void)?, onError:((DataResponse<Any>)->Void)?) {
        submit(.patch, path:path, params:params, onSuccess:onSuccess, onError:onError);
    }
    
    func delete(_ path:String, params:Dictionary<String,String>?, onSuccess:((NSDictionary)->Void)?, onError:((DataResponse<Any>)->Void)?) {
        submit(.delete, path:path, params:params, onSuccess:onSuccess, onError:onError);
    }
    
    fileprivate func submit(_ method:Alamofire.HTTPMethod, path:String, params:Dictionary<String,String>?, onSuccess:((NSDictionary)->Void)?, onError:((DataResponse<Any>)->Void)?) {
        var actualMethod = method
        let headers = getHeaders(method)
        
        if ( method == .put || method == .delete ) {
            actualMethod = .post
        }
        
        let uriBase = YukimotoConfig.GetApiUriBase()
        
        //        Alamofire.request(actualMethod, uriBase + path, headers:headers, parameters:params)
        Alamofire.request(uriBase + path, method: actualMethod, parameters: params, encoding: URLEncoding.default, headers: headers)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                if ( response.result.isSuccess ) {
                    let jsonDic = response.result.value as! NSDictionary
                    onSuccess?(jsonDic)
                } else {
                    onError?(response)
                }
        }
    }
    
    func putRaw(_ path:String, data:Data, onSuccess:((NSDictionary)->Void)?, onError:((DataResponse<Any>?)->Void)?) {
        
        let dirUrl = URL(fileURLWithPath: NSTemporaryDirectory() + ProcessInfo.processInfo.globallyUniqueString, isDirectory: true)
        try! FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true, attributes: nil);
        
        let fileUrl = dirUrl.appendingPathComponent("tmp_upload.data");
        let fileUrlStr = fileUrl.path
        let result = (try? data.write(to: URL(fileURLWithPath: fileUrlStr), options: [.atomic])) != nil
        if ( !result ) {
            onError?(nil)
        }
        let headers = getHeaders(.put)
        let uriBase = YukimotoConfig.GetApiUriBase()
        
        //        Alamofire.upload(.put, uriBase + path, headers:headers, file:fileUrl)
        Alamofire.upload(fileUrl, to: uriBase + path, method: .put, headers: headers)
            .validate(contentType: ["application/octet-stream"])
            .responseJSON { response in
                if ( response.result.isSuccess ) {
                    let jsonDic = response.result.value as! NSDictionary
                    onSuccess?(jsonDic)
                } else {
                    onError?(response)
                }
        }
    }
    
    fileprivate func getHeaders(_ method:Alamofire.HTTPMethod) -> Dictionary<String,String> {
        var headers = Dictionary<String,String>();
        headers["X-HTTP-Method-Override"] = method.rawValue
        if let it = self.token {
            headers["X-RAPPR-TOKEN"] = it.token
        }
        
        return headers;
    }
    
}
