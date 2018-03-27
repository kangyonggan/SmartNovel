//
//  BookTableCell.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class NovelTableViewCell: UITableViewCell {
    
    // 组件
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    // 初始化
    func initView(_ novel: Novel) {
        nameLabel.text = novel.name;
        authorLabel.text = novel.author;
        descLabel.text = novel.descp.isEmpty ? "暂无简介" : novel.descp;
        
        // 异步加载封面
        CacheImage().load(named: novel.picUrl, to: coverImage, withDefault: AppConstants.NO_COVER_IMAGE);
    }
    
    
}


