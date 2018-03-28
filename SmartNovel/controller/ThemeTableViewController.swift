//
//  ThemeTableViewController.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//


import UIKit

class ThemeTableViewController: UITableViewController {
    
    let CELL_ID = "ThemeTableCell";
    
    var themes = [(String, String)]();
    
    let dictionaryDao = DictionaryDao();
    
    var selectedValue: String!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        initView();
    }
    
    func initView() {
        let dict = dictionaryDao.findDictionaryBy(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.THEME);
        if dict == nil {
            selectedValue = "#FFFFFF";
        } else {
            selectedValue = dict!.value;
        }
        
        themes = AppConstants.themes();
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ThemeTableCell;
        
        let theme = themes[indexPath.row];
        
        cell.initData(theme.0, isSelected: selectedValue == theme.1);
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theme = themes[indexPath.row];
        
        let dict = Dictionary();
        dict.type = DictionaryKey.TYPE_DEFAULT;
        dict.key = DictionaryKey.THEME;
        dict.value = theme.1;
        
        dictionaryDao.delete(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.THEME);
        
        dictionaryDao.save(dict);
        
        self.navigationController?.popViewController(animated: true);
        
    }
}



