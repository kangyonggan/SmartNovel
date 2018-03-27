//
//  CategoryCollectionView.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just;

class CategoryCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 拿到主view的引用是为了进行界面跳转，因为子view是不能跳转界面的
    var viewController: UIViewController!;
    
    // 热门分类
    var categories = [Category]();
    
    // 选中的分类
    var selectedCategory: Category!;
    
    // 加载中菊花
    var loadingView: UIActivityIndicatorView!;
    
    // 加载数据
    func loadData(_ categories: [Category]) {
        self.categories = categories;
        // 调用此方法会重新渲染单元格，也就是会调用下面的下面的下面那个方法
        self.reloadData();
    }
    
    // 类似excel的sheet个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    // 返回单元格总数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count;
    }
    
    // 渲染单元格
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as! CategoryCollectionCell;
        
        cell.initData(categories[indexPath.row]);
        
        return cell;
    }
    
    // 单元格选中事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading() {
            return;
        }
        
        selectedCategory = categories[indexPath.row];
        
        // 启动加载中菊花
        loadingView = ViewUtil.loadingView(viewController.view);
        
        // 使用异步请求
        Http.post(UrlConstants.NOVEL_CATEGORY, params: ["categoryCode": selectedCategory.code], callback: novelCategoryCallback)
    }
    
    // 回调
    func novelCategoryCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        var resNovels = [Novel]();
        if result.0 {
            let novels = result.2["novels"] as! NSArray;
            for n in novels {
                let nn = n as! NSDictionary
                let novel = Novel(nn);
                
                resNovels.append(novel);
            }
        } else {
            Toast.showMessage(result.1, onView: self)
            return;
        }
        
        DispatchQueue.main.async {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NovelTableViewController") as! NovelTableViewController;
            vc.novels = resNovels;
            vc.refreshNav(self.selectedCategory.name)
            self.viewController.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    // 判断是否正在加载
    func isLoading() -> Bool {
        return loadingView != nil && loadingView.isAnimating;
    }
    
    // 停止加载中动画
    func stopLoading() {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating();
            self.loadingView.removeFromSuperview();
        }
    }
    
}


