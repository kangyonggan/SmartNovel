//
//  CacheImage.swift
//  future-v2
//
//  Created by kangyonggan on 8/29/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class CacheImage: UIImage {
    
    var imageView: UIImageView!;
    var name: String!;
    var defaultName: String!;
    
    func load(named: String, to: UIImageView, withDefault: String) {
        self.name = named;
        self.imageView = to;
        self.defaultName = withDefault;
        
        // 先看本地缓存有没有图片
        let img = FileUtil.readImage(named);
        if img == nil {
            // 本地如果没有，再走请求
            Http.get(named, callback: callback);
        } else {
            self.imageView.image = img;
        }
    }
    
    // 加载封面的回调
    func callback(res: HTTPResult) {
        if res.ok {
            let img = UIImage(data: res.content!)
            
            DispatchQueue.main.async {
                self.imageView.image = img;
            }
            
            // 把图片缓存到本地
            FileUtil.writeImage(img!, withName: name);
        } else {
            let img = UIImage(named: self.defaultName);
            DispatchQueue.main.async {
                self.imageView.image = img;
            }
        }
    }
}


