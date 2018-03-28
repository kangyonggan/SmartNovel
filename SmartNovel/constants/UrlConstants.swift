//
//  UrlConstants.swift
//  future-v2
//
//  Created by kangyonggan on 8/24/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation

// 请求地址常量
class UrlConstants: NSObject {
    
    // 域名
    static let DOMAIN = "https://kangyonggan.com/";
//    static let DOMAIN = "http://127.0.0.1:8080/";
    
    // 手机端前缀
    static let MOBILE = "mobile/";
    
    // 全部分类
    static let CATEGORY_ALL = MOBILE + "category/all";
    
    // 搜索小说
    static let NOVEL_SEARCH = MOBILE + "novel/search";
    
    // 分类小说
    static let NOVEL_CATEGORY = MOBILE + "novel/category";
    
    // 小说第一章
    static let SECTION_FIRST = MOBILE + "section/first";
    
    // 查找章节
    static let SECTION = MOBILE + "section";
    
    // 查找下一章节
    static let SECTION_NEXT = MOBILE + "section/next";
    
    // 查找上一章节
    static let SECTION_PREV = MOBILE + "section/prev";
    
    // 章节缓存
    static let SECTION_CACHE = MOBILE + "section/cache";
    
    // 全部章节
    static let SECTION_ALL = MOBILE + "section/all";
    
}


