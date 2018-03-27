//
//  BookDao.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//


import UIKit
import CoreData

class NovelDao: NSObject {
    
    var managedObjectContext: NSManagedObjectContext!
    let entityName = "TNovel";
    
    override init() {
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // 保存小说
    func save(_ novel: Novel) {
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext);
        
        newEntity.setValue(novel.code, forKey: "code");
        newEntity.setValue(novel.name, forKey: "name");
        newEntity.setValue(novel.author, forKey: "author");
        newEntity.setValue(novel.categoryCode, forKey: "categoryCode");
        newEntity.setValue(novel.categoryName, forKey: "categoryName");
        newEntity.setValue(novel.picUrl, forKey: "picUrl");
        newEntity.setValue(novel.descp, forKey: "descp");
        newEntity.setValue(novel.newSectionCode, forKey: "newSectionCode");
        newEntity.setValue(novel.newSectionTitle, forKey: "newSectionTitle");
        newEntity.setValue(novel.lastSectionCode, forKey: "lastSectionCode");
        newEntity.setValue(novel.isFavorite, forKey: "isFavorite");
        newEntity.setValue(Date(), forKey: "createdTime");
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError();
        }
    }
    
    // 删除小说
    func delete(code: Int) {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "code=%@", String(code));
            request.predicate = predicate;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            for row in rows {
                managedObjectContext.delete(row);
            }
            
            try managedObjectContext.save();
        }catch{
            fatalError();
        }
    }
    
    // 查找收藏的小说
    func findAllFavoriteNovels() -> [Novel] {
        var novels = [Novel]();
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
            request.predicate = predicate;
            
            // 倒序
            var sorts = [NSSortDescriptor]();
            sorts.append(NSSortDescriptor(key: "createdTime", ascending: false));
            request.sortDescriptors = sorts;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            
            for row in rows {
                let dict = Novel();
                dict.code = (row.value(forKey: "code") as? Int)!;
                dict.name = (row.value(forKey: "name") as? String)!;
                dict.author = (row.value(forKey: "author") as? String)!;
                dict.categoryCode = (row.value(forKey: "categoryCode") as? String)!;
                dict.categoryName = (row.value(forKey: "categoryName") as? String)!;
                dict.picUrl = (row.value(forKey: "picUrl") as? String)!;
                dict.descp = (row.value(forKey: "descp") as? String)!;
                dict.newSectionCode = (row.value(forKey: "newSectionCode") as? Int);
                dict.newSectionTitle = (row.value(forKey: "newSectionTitle") as? String);
                dict.lastSectionCode = (row.value(forKey: "lastSectionCode") as? Int);
                dict.isFavorite = (row.value(forKey: "isFavorite") as? Bool);
                
                novels.append(dict);
            }
        }catch{
            fatalError();
        }
        
        return novels;
    }
    
    // 查询小说
    func findNovelByCode(_ code: Int) -> Novel? {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "code=%@", String(code));
            request.predicate = predicate;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            let dict = Novel();
            for row in rows {
                dict.code = (row.value(forKey: "code") as? Int)!;
                dict.name = (row.value(forKey: "name") as? String)!;
                dict.author = (row.value(forKey: "author") as? String)!;
                dict.categoryCode = (row.value(forKey: "categoryCode") as? String)!;
                dict.categoryName = (row.value(forKey: "categoryName") as? String)!;
                dict.picUrl = (row.value(forKey: "picUrl") as? String)!;
                dict.descp = (row.value(forKey: "descp") as? String)!;
                dict.newSectionCode = (row.value(forKey: "newSectionCode") as? Int);
                dict.newSectionTitle = (row.value(forKey: "newSectionTitle") as? String);
                dict.lastSectionCode = (row.value(forKey: "lastSectionCode") as? Int);
                dict.isFavorite = (row.value(forKey: "isFavorite") as? Bool);
                
                return dict;
            }
        }catch{
            fatalError();
        }
        
        return nil;
    }
}


