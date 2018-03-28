//
//  SectionDao.swift
//  future-v2
//
//  Created by kangyonggan on 8/25/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit
import CoreData

class SectionDao: NSObject {
    
    var managedObjectContext: NSManagedObjectContext!
    let entityName = "TSection";
    
    override init() {
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // 批量保存章节
    func save(_ sections: [Section]) {
        for section in sections {
            let newEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext);
            
            newEntity.setValue(section.code, forKey: "code");
            newEntity.setValue(section.title, forKey: "title");
            newEntity.setValue(section.novelCode, forKey: "novelCode");
            newEntity.setValue(section.content, forKey: "content");
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError();
        }
    }
    
    // 删除某小说的缓存章节
    func deleteSections(_ byNovelCode: Int) {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "novelCode=%@", String(byNovelCode));
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
    
    // 根据章节代码查找章节
    func findSection(_ byCode: Int) -> Section? {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "code=%@", String(byCode));
            request.predicate = predicate;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            let dict = Section();
            for row in rows {
                dict.code = (row.value(forKey: "code") as? Int)!;
                dict.title = (row.value(forKey: "title") as? String)!;
                dict.content = (row.value(forKey: "content") as? String)!;
                dict.novelCode = (row.value(forKey: "novelCode") as? Int)!;
                
                return dict;
            }
        }catch{
            fatalError();
        }
        
        return nil;
    }
    
    // 查找下一章节
    func findNextSection(_ section: Section) -> Section? {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "novelCode=%@ and code>%@", String(section.novelCode), String(section.code));
            request.predicate = predicate;
            
            // 升序
            let sorts = [NSSortDescriptor(key: "code", ascending: true)];
            request.sortDescriptors = sorts;
            
            request.fetchLimit = 1;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            let dict = Section();
            for row in rows {
                dict.code = (row.value(forKey: "code") as? Int)!;
                dict.title = (row.value(forKey: "title") as? String)!;
                dict.content = (row.value(forKey: "content") as? String)!;
                dict.novelCode = (row.value(forKey: "novelCode") as? Int)!;
                
                return dict;
            }
        }catch{
            fatalError();
        }
        
        return nil;
    }
    
    // 查找上一章节
    func findPrevSection(_ section: Section) -> Section? {
        do{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
            let predicate = NSPredicate(format: "novelCode=%@ and code<%@", String(section.novelCode), String(section.code));
            request.predicate = predicate;
            
            // 升序
            let sorts = [NSSortDescriptor(key: "code", ascending: false)];
            request.sortDescriptors = sorts;
            
            request.fetchLimit = 1;
            
            let rows = try managedObjectContext.fetch(request) as! [NSManagedObject];
            
            let dict = Section();
            for row in rows {
                dict.code = (row.value(forKey: "code") as? Int)!;
                dict.title = (row.value(forKey: "title") as? String)!;
                dict.content = (row.value(forKey: "content") as? String)!;
                dict.novelCode = (row.value(forKey: "novelCode") as? Int)!;
                
                return dict;
            }
        }catch{
            fatalError();
        }
        
        return nil;
    }
}


