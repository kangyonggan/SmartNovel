//
//  SectionTableCell.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class SectionTableCell: UITableViewCell {
    
    // 控件
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func initData(_ name: String, isSelected: Bool) {
        nameLabel.text = name;
        
        if !isSelected {
            leftImage.isHidden = true;
        } else {
            leftImage.isHidden = false;
        }
    }
    
}


