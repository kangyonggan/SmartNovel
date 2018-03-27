//
//  Category.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation

// 分类
class Category: NSObject {
    
    override init() {
        
    }
    
    init(_ dic: NSDictionary) {
        self.code = dic["code"] as? String;
        self.name = dic["name"] as? String;
        self.novelCnt = dic["novelCnt"] as? Int;
    }
    
    // 分类代码
    var code: String!;
    
    // 分类名称
    var name: String!;
    
    // 此分类小说数量
    var novelCnt: Int!;
    
}


