//
//  CategoryCollectionCell.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    
    // 控件
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var novelCntLabel: UILabel!
    
    // 初始化数据
    func initData(_ category: Category) {
        nameLabel.text = category.name;
        novelCntLabel.text = "\(category.novelCnt!) 本";
    }
    
}

