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
        
    }
  
}


