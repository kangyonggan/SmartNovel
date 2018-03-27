//
//  ViewUtil.swift
//  future-v2
//
//  Created by kangyonggan on 8/24/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class ViewUtil: NSObject {
    
    // 给控件加下边框
    static func addBorderBottom(_ view: UIView, withColor: UIColor) {
        let line = UIView(frame: CGRect(x: 0, y: view.frame.height - 1, width: view.frame.width, height: 1));
        line.backgroundColor = withColor;
        view.addSubview(line);
    }
    
    // 给文本框添加左侧图标
    static func addLeftView(_ textField: UITextField, withIcon: String, width: Int, height: Int) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height));
        imageView.image = UIImage(named: withIcon);
        textField.leftView = imageView;
        textField.leftViewMode = UITextFieldViewMode.always;
    }
    
    // 加载中图标
    static func loadingView(_ fromParentView: UIView) -> UIActivityIndicatorView {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        loadingView.color = AppConstants.MASTER_COLOR
        loadingView.center = fromParentView.center;
        loadingView.hidesWhenStopped = true;
        
        fromParentView.addSubview(loadingView)
        loadingView.startAnimating();
        
        return loadingView;
    }
}


