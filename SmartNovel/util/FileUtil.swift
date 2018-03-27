//
//  FileUtil.swift
//  future-v2
//
//  Created by kangyonggan on 8/29/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class FileUtil: NSObject {
    
    // 获取本地全部音乐
    static func getAllMusic() -> [URL] {
        let musics = readAllMp3();
        
        return musics;
    }
    
    // 写图片
    static func writeImage(_ image: UIImage, withName: String) {
        let fileManager = FileManager.default;
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        // 判断文件、目录是否存在，如果不存在就创建目录
        if !fileManager.fileExists(atPath: rootPath + "/images/upload") {
            try! fileManager.createDirectory(atPath: rootPath + "/images/upload", withIntermediateDirectories: true, attributes: nil)
        }
        if !fileManager.fileExists(atPath: rootPath + "/images/cover") {
            try! fileManager.createDirectory(atPath: rootPath + "/images/cover", withIntermediateDirectories: true, attributes: nil)
        }
        
        let filePath = rootPath + "/images/" + withName;
        let imageData = UIImagePNGRepresentation(image);
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
    }
    
    // 写mp3文件
    static func writeMp3(_ data: Data, withName: String) {
        let fileManager = FileManager.default;
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        // 判断文件、目录是否存在，如果不存在就创建目录
        if !fileManager.fileExists(atPath: rootPath + "/music") {
            try! fileManager.createDirectory(atPath: rootPath + "/music", withIntermediateDirectories: true, attributes: nil)
        }
        
        let filePath = rootPath + "/music/" + withName;
        fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
    }
    
    // 读图片
    static func readImage(_ named: String) -> UIImage? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath + "/images/").appendingPathComponent(named);
            let image    = UIImage(contentsOfFile: imageURL.path)
            return image;
        }
        
        return nil;
    }
    
    // 读MP3
    static func readMp3(_ named: String) -> URL? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            return URL(fileURLWithPath: dirPath + "/music/").appendingPathComponent(named);
            
        }
        
        return nil;
    }
    
    // 删除本地mp3
    static func deleteMp3(_ info: (String, String)) {
        let fileManager = FileManager.default
        let myDirectory = NSHomeDirectory() + "/Documents/music/"
        
        try! fileManager.removeItem(atPath: myDirectory + info.1 + " - " + info.0 + ".mp3")
    }
    
    // 读取本地全部mp3
    static func readAllMp3() -> [URL] {
        let fileManager = FileManager.default;
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        // 判断文件、目录是否存在，如果不存在就创建目录
        if !fileManager.fileExists(atPath: rootPath + "/music") {
            try! fileManager.createDirectory(atPath: rootPath + "/music", withIntermediateDirectories: true, attributes: nil)
        }
        
        var files = [URL]();
        let myDirectory = NSHomeDirectory() + "/Documents/music"
        let fileArray = fileManager.subpaths(atPath: myDirectory)
        for fn in fileArray! {
            if fn.contains(".mp3") {
                let url = URL(fileURLWithPath: myDirectory).appendingPathComponent(fn);
                files.append(url);
            }
        }
        
        return files;
    }
}


