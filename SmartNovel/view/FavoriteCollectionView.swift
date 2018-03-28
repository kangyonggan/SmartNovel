//
//  CategoryCollectionView.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class FavoriteCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 拿到主view的引用是为了进行界面跳转，因为子view是不能跳转界面的
    var viewController: UIViewController!;
    
    // 收藏的小说
    var novels = [Novel]();
    
    // 加载中菊花
    var loadingView: UIActivityIndicatorView!;
    
    // 选中的小说
    var selectedNovel: Novel!;
    
    // 数据库
    let novelDao = NovelDao();
    let sectionDao = SectionDao();
    
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
        if isLoading() {
            return;
        }
        
        selectedNovel = novels[indexPath.row];
        
        // 尝试从本地获取章节
        let section = sectionDao.findSection((selectedNovel.lastSectionCode)!);
        
        if section != nil {// 本地有缓存此章节，直接跳到章节详情
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SectionDetailController") as! SectionDetailController;
            vc.novel = self.selectedNovel;
            vc.section = section;
            viewController.navigationController?.pushViewController(vc, animated: true);
        } else {// 本地没有缓存此章节，调接口
            // 加载中菊花
            loadingView = ViewUtil.loadingView(viewController.view);
            
            // 异步加载
            Http.post(UrlConstants.SECTION, params: ["novelCode": selectedNovel.code, "code": selectedNovel.lastSectionCode!], callback: sectionCallback);
        }
    }
    
    // 查找章节的回调
    func sectionCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        var section: Section!;
        if result.0 {
            let ss = result.2["section"] as! NSDictionary;
            section = Section(ss);
        } else {
            Toast.showMessage(result.1, onView: self)
            return;
        }
        
        DispatchQueue.main.async {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SectionDetailController") as! SectionDetailController;
            vc.novel = self.selectedNovel;
            vc.section = section;
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



