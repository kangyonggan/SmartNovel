//
//  CategoryCollectionView.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class FavoriteCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 拿到主view的引用是为了进行界面跳转，因为子view是不能跳转界面的
    var viewController: UIViewController!;
    
    // 收藏的小说
    var novels = [Novel]();
    
    // 加载数据
    func loadData(_ novels: [Novel]) {
        self.novels = novels;
        self.reloadData();
    }
    
    // 类似excel的sheet个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    // 返回单元格总数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return novels.count;
    }
    
    // 渲染单元格
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionCell", for: indexPath) as! FavoriteCollectionCell;
        
        cell.initData(novels[indexPath.row]);
        
        return cell;
    }
    
    // 单元格选中事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}



