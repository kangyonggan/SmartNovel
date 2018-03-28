//
//  SettingController.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import Just

class SettingController: UIViewController {
    
    // 控件
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var cacheSwitch: UISwitch!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    @IBOutlet weak var sectionTitle: UILabel!
    
    // 数据库
    let dictionaryDao = DictionaryDao();
    let sectionDao = SectionDao();
    let novelDao = NovelDao();
    
    // 数据
    var novel:Novel!;
    var section: Section!;
    var sections = [Section]();
    var viewController: SectionDetailController!;
    
    // 主题
    var themes = [(String, String)]();
    
    // 加载中菊花图标
    var loadingView: UIActivityIndicatorView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView();
    }
    
    // 初始化界面
    func initView() {
        self.navigationController?.setNavigationBarHidden(false, animated: false);
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: nil, action: nil)
        themes = AppConstants.themes();
        
        // 初始化字体大小控件
        let fontDict = dictionaryDao.findDictionaryBy(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.FONT_SIZE);
        
        if fontDict == nil {
            slider.setValue(22, animated: false);
        } else {
            slider.setValue(Float((fontDict!.value)!)!, animated: true);
        }
        
        // 初始化缓存开关
        let cacheDict = dictionaryDao.findDictionaryBy(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.AUTO_CACHE);
        if cacheDict == nil {
            cacheSwitch.isOn = true;
        } else {
            if cacheDict!.value == "1" {
                cacheSwitch.isOn = true;
            } else {
                cacheSwitch.isOn = false;
            }
        }
        
        // 初始化收藏开关
        let nv = novelDao.findNovelByCode(novel.code);
        if nv != nil && nv!.isFavorite {
            favoriteSwitch.isOn = true;
        } else {
            favoriteSwitch.isOn = false;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        updateThemeLabel();
        
        // 设置当前章节的标题
        sectionTitle.text = section.title;
    }
    
    func updateThemeLabel() {
        let dict = dictionaryDao.findDictionaryBy(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.THEME);
        
        if dict != nil {
            for theme in themes {
                if theme.1 == dict!.value {
                    themeLabel.text = theme.0;
                    break;
                }
            }
        }
    }
    
    // 修改字体大小
    @IBAction func changeSize(_ sender: Any) {
        dictionaryDao.delete(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.FONT_SIZE)
        
        let dict = Dictionary();
        dict.type = DictionaryKey.TYPE_DEFAULT;
        dict.key = DictionaryKey.FONT_SIZE;
        dict.value = String(slider.value);
        
        dictionaryDao.save(dict);
    }
    
    // 加入缓存
    @IBAction func addToFavorite(_ sender: Any) {
        novelDao.delete(code: novel.code);
        
        novel.isFavorite = !novel.isFavorite;
        novel.lastSectionCode = section.code;
        novelDao.save(novel);
    }
    
    // 开启缓存
    @IBAction func openCache(_ sender: Any) {
        let isOn = (sender as? UISwitch)?.isOn;
        
        dictionaryDao.delete(type: DictionaryKey.TYPE_DEFAULT, key: DictionaryKey.AUTO_CACHE);
        
        let dict = Dictionary();
        dict.type = DictionaryKey.TYPE_DEFAULT;
        dict.key = DictionaryKey.AUTO_CACHE;
        dict.value = isOn! ? "1" : "0";
        
        dictionaryDao.save(dict);
    }
    
    // 章节列表
    @IBAction func sectionList(_ sender: Any) {
        if isLoading() {
            return;
        }
        
        if sections.isEmpty {
            // 启动加载中菊花
            loadingView = ViewUtil.loadingView(self.view);
            
            // 使用异步请求
            Http.post(UrlConstants.SECTION_ALL, params: ["novelCode": novel.code], callback: sectionsCallback)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SectionTableViewController") as! SectionTableViewController;
            vc.sections = self.sections;
            vc.selectedSection = self.section;
            vc.novel = self.novel;
            vc.settingController = self;
            vc.viewController = self.viewController;
            vc.refreshNav(self.novel.name!);
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    // 加载章节列表的回调
    func sectionsCallback(res: HTTPResult) {
        stopLoading();
        
        let result = Http.parse(res);
        
        if result.0 {
            let resSections = result.2["sections"] as! NSArray;
            for s in resSections {
                let ss = s as! NSDictionary
                let section = Section(ss);
                
                self.sections.append(section);
            }
            
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SectionTableViewController") as! SectionTableViewController;
                vc.sections = self.sections;
                vc.selectedSection = self.section;
                vc.novel = self.novel;
                vc.viewController = self.viewController;
                vc.settingController = self;
                vc.refreshNav(self.novel.name);
                self.navigationController?.pushViewController(vc, animated: true);
            }
        } else {
            Toast.showMessage(result.1, onView: self.view);
        }
    }
    
    // 清空缓存
    @IBAction func clearCache(_ sender: Any) {
        sectionDao.deleteSections(self.novel.code);
        Toast.showMessage("缓存已经清空", onView: self.view);
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


