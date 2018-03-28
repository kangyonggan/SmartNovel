//
//  self.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation

// 小说
class Novel: NSObject {
    
    override init() {
        
    }
    
    init(_ bk: NSDictionary) {
        self.code = bk["code"] as? Int;
        self.name = bk["name"] as? String;
        self.author = bk["author"] as? String;
        self.categoryCode = bk["categoryCode"] as? String;
        self.picUrl = bk["picUrl"] as? String;
        self.descp = bk["descp"] as? String;
        
        // 缺省值
        self.lastSectionCode = 0;
        self.isFavorite = false;
    }
    
    // 小说代码
    var code: Int!;
    
    // 小说名称
    var name: String!;
    
    // 作者
    var author: String!;
    
    // 分类代码
    var categoryCode: String!;
    
    // 封面
    var picUrl: String!;
    
    // 简介
    var descp: String!;
    
    // 最后阅读章节代码
    var lastSectionCode: Int!;
    
    // 是否收藏
    var isFavorite: Bool!;
}



