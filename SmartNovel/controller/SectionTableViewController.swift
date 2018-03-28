//
//  SectionTableViewController.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//


import UIKit
import Just

class SectionTableViewController: UITableViewController {
    
    let CELL_ID = "SectionTableCell";
    
    // 加载中菊花
    var loadingView: UIActivityIndicatorView!;
    
    // 数据
    var novel: Novel!;
    var sections = [Section]();
    var selectedSection: Section!;
    var viewController: SectionDetailController!;
    var settingController: SettingController!;
    
    // 数据库
    let sectionDao = SectionDao();
    let novelDao = NovelDao();
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    // 刷新导航栏标题
    func refreshNav(_ title: String) {
        self.navigationItem.title = title;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        // 跳转到当前章节的cell
        let row = clacSectionRow();
        let indexPath = IndexPath(row: row, section: 0);
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true);
        
        self.navigationController?.setNavigationBarHidden(false, animated: false);
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! SectionTableCell;
        
        let section = sections[indexPath.row];
        
        cell.initData(section.title!, isSelected: selectedSection.code == section.code);
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading() {
            return;
        }
        
        selectedSection = sections[indexPath.row]
        
        // 先走缓存，如果缓存有，直接使用
        // 如果缓存中没有，则调接口
        let tSection = sectionDao.findSection(selectedSection.code);
        if tSection == nil {
            // 没缓存，走接口查询
            loadingView = ViewUtil.loadingView(self.tableView);
            
            // 使用异步请求
            Http.post(UrlConstants.SECTION, params: ["novelCode": novel.code, "code": selectedSection.code], callback: sectionCallback)
        } else {
            // 有缓存, 直接使用
            viewController.section = tSection;
            viewController.updateContent();
            settingController.section = tSection;
            
            // 更新最后阅读章节
            updateLastNovelSection()
            
            // 返回上一个界面
            self.navigationController?.popViewController(animated: true);
        }
    }
    
    // 更新本地小说的最后阅读章节
    func updateLastNovelSection() {
        DispatchQueue.main.async {
            self.novel.lastSectionCode = self.selectedSection.code;
            self.novelDao.delete(code: self.novel.code);
            self.novelDao.save(self.novel);
        }
    }
    
    // 加载章节的回调
    func sectionCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
            let ss = result.2["section"] as! NSDictionary;
            self.selectedSection = Section(ss);
            
            // 更新最后阅读章节
            updateLastNovelSection()
            
            // 返回上一个界面
            DispatchQueue.main.async {
                self.viewController.section = self.selectedSection;
                self.viewController.updateContent();
                self.settingController.section = self.selectedSection;
                self.navigationController?.popViewController(animated: true);
            }
        } else {
            Toast.showMessage(result.1, onView: self.view);
            return;
        }
    }
    
    // 计算当前章节所在的行
    func clacSectionRow() -> Int {
        var row = 0;
        for section in sections {
            if section.code == selectedSection.code {
                return row;
            }
            row += 1;
        }
        
        return -1;
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


