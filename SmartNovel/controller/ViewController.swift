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
    
    // 搜索按钮
    @IBOutlet weak var searchButton: UIButton!
    
    // 搜索框
    @IBOutlet weak var searchTextField: UITextField!
    
    // 加载中菊花
    var loadingView: UIActivityIndicatorView!;
    
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
        // 返回按钮
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        
        // 修改返回按钮的颜色
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        // 搜索框样式
        searchTextField.layer.borderWidth = 1;
        searchTextField.layer.cornerRadius = 3;
        searchTextField.layer.borderColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1).cgColor;
        ViewUtil.addLeftView(searchTextField, withIcon: "search", width: 25, height: 25);
        
        // 搜索按钮样式
        searchButton.layer.cornerRadius = 5;
        
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

    // 结束输入（立即搜索）
    @IBAction func end(_ sender: Any) {
        search(sender);
    }
    
    // 搜索
    @IBAction func search(_ sender: Any) {
        if isLoading() {
            return;
        }
        
        // 收起键盘
        UIApplication.shared.keyWindow?.endEditing(true);
        
        // 焦点给搜索按钮
        searchButton.becomeFirstResponder();
        
        // 关键字
        let key = searchTextField.text!;
        
        // 判断非空
        if key.isEmpty {
            Toast.showMessage("请输入搜索内容！", onView: self.view);
            return;
        }
        
        // 加载中菊花
        loadingView = ViewUtil.loadingView(self.view);
        
        // 异步加载
        Http.post(UrlConstants.NOVEL_SEARCH, params: ["key": key], callback: novelSearchCallback)
    }
    
    // 搜索小说的回调
    func novelSearchCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        var resNovels = [Novel]();
        if result.0 {
            let novels = result.2["novels"] as! NSArray;
            for b in novels {
                let bk = b as! NSDictionary
                let novel = Novel(bk);
                
                resNovels.append(novel);
            }
        } else {
            Toast.showMessage(result.1, onView: self.view)
            return;
        }
        
        if resNovels.isEmpty {
            Toast.showMessage("没有符合条件的小说", onView: self.view);
            return;
        }
        
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NovelTableViewController") as! NovelTableViewController;
            vc.novels = resNovels;
            vc.refreshNav("搜索结果")
            self.navigationController?.pushViewController(vc, animated: true);
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

