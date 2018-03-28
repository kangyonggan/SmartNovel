//
//  BookListController.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class NovelTableViewController: UITableViewController {
    
    let CELL_ID = "NovelTableViewCell";
    var novels = [Novel]();
    
    // 加载中菊花
    var loadingView: UIActivityIndicatorView!;
    
    // 选中的小说
    var selectedNovel: Novel!;
    
    // 数据库
    let novelDao = NovelDao();
    let sectionDao = SectionDao();
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    func refreshNav(_ title: String) {
        self.navigationItem.title = title;
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return novels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! NovelTableViewCell;
        
        let novel = novels[indexPath.row]
        
        cell.initView(novel);
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading() {
            return;
        }
        
        selectedNovel = novels[indexPath.row];
        
        // 从本地读取book，获取用户最后读取的章节代码
        let novel = novelDao.findNovelByCode(selectedNovel.code);
        
        // 如果本地没有，走接口获取小说第一章节
        if novel == nil {
            // 加载中菊花
            loadingView = ViewUtil.loadingView(self.view);
            
            // 异步加载第一章
            Http.post(UrlConstants.SECTION_FIRST, params: ["novelCode": selectedNovel.code], callback: sectionCallback);
        } else {
            // 尝试从本地获取章节
            let section = sectionDao.findSection((novel?.lastSectionCode)!);
            
            if section != nil {// 本地有缓存此章节，直接跳到章节详情
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SectionDetailController") as! SectionDetailController;
                vc.novel = self.selectedNovel;
                vc.section = section;
                self.navigationController?.pushViewController(vc, animated: true);
            } else {// 本地没有缓存此章节，调接口
                // 加载中菊花
                loadingView = ViewUtil.loadingView(self.view);
                
                // 异步加载
                Http.post(UrlConstants.SECTION, params: ["code": novel!.lastSectionCode!], callback: sectionCallback);
            }
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
            Toast.showMessage(result.1, onView: self.tableView)
            return;
        }
        
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SectionDetailController") as! SectionDetailController;
            vc.novel = self.selectedNovel;
            vc.section = section;
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


