//
//  Toast.swift
//  future-v2
//
//  Created by kangyonggan on 8/24/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import Foundation
import Toast_Swift;

class Toast: NSObject {
    
    // 提示信息
    static func showMessage(_ msg: String, onView: UIView) {
        DispatchQueue.main.async {
            onView.makeToast(msg, duration: 2, position: .center)
        }
    }
    
}


