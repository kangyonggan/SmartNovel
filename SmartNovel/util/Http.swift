//
//  Http.swift
//  future-v2
//
//  Created by kangyonggan on 8/24/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation
import Just

class Http: NSObject {
    
    // 异步get，不带参数, 有回调
    static func get(_ url: String, callback: @escaping ((HTTPResult) -> Void)) {
        Just.get(UrlConstants.DOMAIN + url, asyncCompletionHandler: callback);
    }
    
    // 异步post，不带参数, 有回调
    static func post(_ url: String, callback: @escaping ((HTTPResult) -> Void)) {
        Just.post(UrlConstants.DOMAIN + url, timeout: AppConstants.TIMEOUT, asyncCompletionHandler: callback);
    }
    
    // 异步post, 带参数, 有回调
    static func post(_ url: String, params: [String: Any], callback: @escaping ((HTTPResult) -> Void)) {
        Just.post(UrlConstants.DOMAIN + url, data: params, timeout: AppConstants.TIMEOUT, asyncCompletionHandler: callback);
    }
    
    // 异步post, 不带参数, 无回调
    static func post(_ url: String) {
        Just.post(UrlConstants.DOMAIN + url, timeout: AppConstants.TIMEOUT);
    }
    
    // 异步post, 带参数, 无回调
    static func post(_ url: String, params: [String: Any]) {
        Just.post(UrlConstants.DOMAIN + url, data: params, timeout: AppConstants.TIMEOUT);
    }
    
    // 文件上传，带参数，带回调
    static func post(_ url: String, params: [String: Any], file: [String: HTTPFile], callback: @escaping ((HTTPResult) -> Void)) {
        Just.post(UrlConstants.DOMAIN + url, data: params, files: file, timeout: AppConstants.TIMEOUT, asyncCompletionHandler: callback);
    }
    
    // 解析结果
    static func parse(_ result: HTTPResult) -> (Bool, String, NSDictionary) {
        var res: (Bool, String, NSDictionary);
        res.0 = false;
        
        if result.ok {
            let response = result.json as! NSDictionary;
            let respCo = response["respCo"] as! String;
            let respMsg = response["respMsg"] as! String;
            
            if respCo == "0000" {
                res.0 = true;
            }
            res.1 = respMsg;
            res.2 = response;
        } else {
            res.1 = "通讯异常，请稍后再试";
            res.2 = NSDictionary();
        }
        
        return res;
    }
    
}


