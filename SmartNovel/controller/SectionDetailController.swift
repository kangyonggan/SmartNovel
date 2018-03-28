//
//  SectionDetailController.swift
//  SmartNovel
//
//  Created by kangyonggan on 3/28/18.
//  Copyright © 2018 kangyonggan. All rights reserved.
//

import UIKit
import Just

class SectionDetailController: UIViewController, UIWebViewDelegate, UIActionSheetDelegate  {
    
    @IBOutlet weak var webView: UIWebView!
    
    // 加载中菊花图标
    var loadingView: UIActivityIndicatorView!;
    
    // 标识, 后台缓存标识
    var isCacheTerminalTask = false;
    
    // 数据
    var novel: Novel!;
    var section: Section!;
    var sections = [Section]();
    
    // 数据库
    let novelDao = NovelDao();
    let sectionDao = SectionDao();
    let dictionaryDao = DictionaryDao();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        // 不显示导航条
        self.navigationController?.setNavigationBarHidden(true, animated: false);
    }
    
    // 初始化界面
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        
        webView.delegate = self;
        
        updateContent();
        
        // 左滑，下一章
        let swipeLeft = UISwipeGestureRecognizer(target:self, action:#selector(swipe(_:)))
        swipeLeft.direction = .left
        self.webView.addGestureRecognizer(swipeLeft);
        
        // 右滑，上一章
        let swipeRight = UISwipeGestureRecognizer(target:self, action:#selector(swipe(_:)))
        swipeRight.direction = .right
        self.webView.addGestureRecognizer(swipeRight);
        
        // 返回
        let swipeBack = UIScreenEdgePanGestureRecognizer(target:self, action:#selector(swipeEdge(_:)))
        swipeBack.edges = UIRectEdge.left //从左边缘开始滑动
        self.webView.addGestureRecognizer(swipeBack)
        
        // 长按, 弹出菜单
        let longPress = UILongPressGestureRecognizer(target:self, action:#selector(longPressDid(_:)))
        self.webView.addGestureRecognizer(longPress)
        
        // 双击收藏/取消
        let tapSingle=UITapGestureRecognizer(target:self,action:#selector(tapSingleDid))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapSingle)
    }
    
    // 上/下一章
    @objc func swipe(_ recognizer:UISwipeGestureRecognizer){
        if recognizer.direction == .right {
            prevSection();
        }else if recognizer.direction == .left {
            nextSection();
        }
    }
    
    // 返回
    @objc func swipeEdge(_ recognizer:UIScreenEdgePanGestureRecognizer){
        NSLog("返回");
    }
    
    // 长按，弹出菜单
    @objc func longPressDid(_ sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            NSLog("长按响应开始")
        } else {
            NSLog("长按响应结束")
        }
    }
    
    // 双击收藏/取消
    @objc func tapSingleDid(){
        NSLog("单击了")
    }
    
    // 更新内容
    func updateContent() {
        DispatchQueue.main.async {
            self.navigationItem.title = self.section.title;
            self.webView.loadHTMLString(self.section.title + "<br/><br/>" + self.section.content, baseURL: nil);
        }
    }
    // 加载上一章
    func prevSection() {
        if isLoading() {
            return;
        }
        
        // 先走缓存，如果缓存有，直接使用
        let tSection = sectionDao.findPrevSection(self.section);
        if tSection == nil {
            // 没缓存，走接口查询
            loadPrevSection(section.code)
        } else {
            // 有缓存, 直接显示章节内容
            self.section = tSection;
            self.updateContent();
            
            // 更新本地小说的最后阅读章节
            updateLastSection();
        }
    }
    
    // 加载下一章
    func nextSection() {
        if isLoading() {
            return;
        }
        
        // 先走缓存，如果缓存有，直接使用
        // 如果缓存中没有，则调接口，如果开启了缓存，后台缓存后面100章
        let tSection = sectionDao.findNextSection(self.section);
        if tSection == nil {
            // 没缓存，走接口查询
            loadNextSection(section.code)

            // 判断是否是自动缓存，如果是，则后台缓存后面100章
            let autoCacheDict = dictionaryDao.findDictionaryBy(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.AUTO_CACHE)
            if autoCacheDict == nil || autoCacheDict!.value! == "1" {
                // 后台缓存100章，并标志“正在缓存”，防止重复调用后台缓存
                if !isCacheTerminalTask {
                    isCacheTerminalTask = true;
                    // 后台缓存100章
                    Http.post(UrlConstants.SECTION_CACHE, params: ["code": section.code], callback: sectionCacheCallback)
                }
            }
        } else {
            // 有缓存, 直接显示章节内容
            self.section = tSection;
            self.updateContent();
            
            // 更新本地小说的最后阅读章节
            updateLastSection();
        }
    }

    // 缓存章节回调
    func sectionCacheCallback(res: HTTPResult) {
        isCacheTerminalTask = false;
        
        let result = Http.parse(res);
        if result.0 {
            var secs = [Section]();
            let resSections = result.2["sections"] as! NSArray;
            for s in resSections {
                let ss = s as! NSDictionary
                let section = Section(ss);
                
                secs.append(section);
            }
            
            // 先删后存
            sectionDao.deleteSections(self.novel.code);
            sectionDao.save(secs);
            
            Toast.showMessage("后面100章节已经缓存", onView: self.view);
        } else {
            Toast.showMessage("网络异常，无法自动缓存后面100章节", onView: self.view);
        }
    }
    
    // 加载上一章节
    func loadPrevSection(_ code: Int) {
        // 启动加载中菊花
        loadingView = ViewUtil.loadingView(self.view);
        
        // 使用异步请求
        Http.post(UrlConstants.SECTION_PREV, params: ["novelCode": novel.code, "code": code], callback: sectionCallback)
    }
    
    // 加载下一章节
    func loadNextSection(_ code: Int) {
        // 启动加载中菊花
        loadingView = ViewUtil.loadingView(self.view);
        
        // 使用异步请求
        Http.post(UrlConstants.SECTION_NEXT, params: ["novelCode": novel.code, "code": code], callback: sectionCallback)
    }
    
    // 加载章节的回调
    func sectionCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
            let ss = result.2["section"] as! NSDictionary;
            self.section = Section(ss);
        } else {
            Toast.showMessage(result.1, onView: self.view);
            return;
        }
        
        updateContent();
        
        updateLastSection();
    }
    
    // 更新本地小说的最后阅读章节
    func updateLastSection() {
        DispatchQueue.main.async {
            self.novel.lastSectionCode = self.section.code;
            self.novelDao.delete(code: self.novel.code);
            self.novelDao.save(self.novel);
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
