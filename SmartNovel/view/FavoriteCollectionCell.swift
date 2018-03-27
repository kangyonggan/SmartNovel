//
//  FavoriteCollectionCell.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class FavoriteCollectionCell: UICollectionViewCell {
    
    // 控件
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // 初始化数据
    func initData(_ novel: Novel) {
        // 封面 异步加载
        CacheImage().load(named: novel.picUrl, to: imageView, withDefault: AppConstants.NO_COVER_IMAGE);
        
        // 书名
        nameLabel.text = novel.name;
    }
}

