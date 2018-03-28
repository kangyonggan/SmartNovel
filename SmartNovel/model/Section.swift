//
//  Section.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation

// 章节
class Section: NSObject {
    
    override init() {
        
    }
    
    init(_ ss: NSDictionary) {
        self.novelCode = ss["novelCode"] as? Int;
        self.code = ss["code"] as? Int;
        self.title = ss["title"] as? String;
        self.content = ss["content"] as? String;
    }
    
    // 小说代码
    var novelCode:Int!;
    
    // 章节代码
    var code: Int!;
    
    // 标题
    var title: String!;
    
    // 内容
    var content: String!;
}


