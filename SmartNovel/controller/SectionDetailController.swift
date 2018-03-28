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
    
    // 数据
    var novel: Novel!;
    var section: Section!;
    var sections = [Section]();
    
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
            NSLog("上一章");
        }else if recognizer.direction == .left {
            NSLog("下一章");
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
    
    
}
