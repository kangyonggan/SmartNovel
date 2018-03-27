//
//  ViewController.swift
//  SmartNovel
//
//  Created by kangyonggan on 3/27/18.
//  Copyright © 2018 kangyonggan. All rights reserved.
//

import UIKit
import Just;

class ViewController: UIViewController {
    
    // 热门分类视图
    @IBOutlet weak var categoryCollectionView: CategoryCollectionView!
    
    // 我的收藏视图
    @IBOutlet weak var favoriteCollectionView: FavoriteCollectionView!
    
    // 小说分类数据
    var categories = [Category]();
    
    // 数据库
    let novelDao = NovelDao();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initView();
        
        initData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 初始化界面
    func initView() {
        // 绑定代理和数据源
        categoryCollectionView.delegate = categoryCollectionView;
        categoryCollectionView.dataSource = categoryCollectionView;
        
        favoriteCollectionView.delegate = favoriteCollectionView;
        favoriteCollectionView.dataSource = favoriteCollectionView;
        
        
        // 引用传递
        categoryCollectionView.viewController = self;
        favoriteCollectionView.viewController = self
    }
    
    // 初始化数据
    func initData() {
        // 加载热门分类
        if categories.isEmpty {
            // 使用异步请求
            Http.post(UrlConstants.CATEGORY_ALL, callback: categoryCallback);
            
        }
        
        // 加载我的收藏
        let novels = novelDao.findAllFavoriteNovels();
        self.favoriteCollectionView.loadData(novels);
    }
    
    // 加载热门分类的回调
    func categoryCallback(res: HTTPResult) {
        let result = Http.parse(res);
        
        if result.0 {
            self.categories = [];
            let categories = result.2["categories"] as! NSArray;
            DispatchQueue.main.async {
                for c in categories {
                    let categoryDic = c as! NSDictionary
                    let category = Category(categoryDic);
                    
                    self.categories.append(category);
                }
                
                // 渲染热门分类视图
                self.categoryCollectionView.loadData(self.categories);
            }
        } else {
            Toast.showMessage("网络错误，无法加载热门分类", onView: self.view);
        }
    }

}

