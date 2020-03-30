//
//  RealmHelper.swift
//  RealmDemo
//
//  Created by admin on 2020/3/26.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class RealmHelper: NSObject {
    
    private class func getDB() -> Realm {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/defaultDB.realm")
        /// 传入路径会自动创建数据库
        let defaultRealm = try! Realm(fileURL: URL.init(string: dbPath)!)
        print("数据库地址->\(defaultRealm.configuration.fileURL?.absoluteString ?? "")")
        return defaultRealm
    }
}


/// 配置
extension RealmHelper  {
    ///  配置数据库
    public class func configRealm() {
        /// 这个方法主要用于数据模型属性增加或删除时的数据迁移，每次模型属性变化时，将 dbVersion 加 1 即可，Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构，移除属性的数据将会被删除。
        let dbVersion : UInt64 = 1
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/defaultDB.realm")
        let config = Realm.Configuration(fileURL: URL.init(string: dbPath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: dbVersion, migrationBlock: { (migration, oldSchemaVersion) in
            
        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { (realm, error) in
            if let _ = realm {
                print("Realm 服务器配置成功!")
            }else if let error = error {
                print("Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
    }
}

///新增
extension RealmHelper {
    
    
    ///新增单条数据
    public class func addObject<T>(object: T){
        
        do {
            let defaultRealm = self.getDB()
            try defaultRealm.write {
                defaultRealm.add(object as! Object)
            }
            print(defaultRealm.configuration.fileURL ?? "")
        } catch {}
        
    }
        
    /// 保存多条数据
    public class func addObjects<T>(by objects : [T]) -> Void {
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.add(objects as! [Object])
        }
        print(defaultRealm.configuration.fileURL ?? "")
    }
    
}

/// 删除
extension RealmHelper {
    
    
    /// 删除单条
    /// - Parameter object: 删除数据对象
    public class func deleteObject<T>(object: T?) {
        
        if object == nil {
            print("无此数据")
            return
        }
        
        do {
              let defaultRealm = self.getDB()
              try defaultRealm.write {
                  defaultRealm.delete(object as! Object)
              }
        } catch {}
    }
    
    
    /// 删除多条数据
    /// - Parameter objects: 对象数组
    public class func deleteObjects<T>(objects: [T]?) {
        
        if objects?.count == 0 {
            print("无此数据")
            return
        }
        
        do {
              let defaultRealm = self.getDB()
              try defaultRealm.write {
                  defaultRealm.delete(objects as! [Object])
              }
        } catch {}
    }

    
    /// 根据条件去删除单条/多条数据
    public class func deleteObjectFilter<T>(objectClass: T, filter: String?) {
        
        let objects = RealmHelper.queryObject(objectClass: objectClass, filter: filter)
        RealmHelper.deleteObjects(objects: objects)
        
    }
    
   
    /// 删除某张表
    /// - Parameter objectClass: 删除对象
      public class func clearTableClass<T>(objectClass: T) {
          
          do {
                let defaultRealm = self.getDB()
                try defaultRealm.write {
                    defaultRealm.delete(defaultRealm.objects((T.self as! Object.Type).self))
                }
          } catch {}
      }
    
}

/// 查
extension RealmHelper {
    
    
    /// 查询数据
    /// - Parameters:
    ///   - objectClass: 当前查询对象
    ///   - filter: 查询条件
    class func queryObject <T> (objectClass: T, filter: String? = nil) -> [T]{
        
        let defaultRealm = self.getDB()
        var results : Results<Object>
        
        if filter != nil {
                 
            results =  defaultRealm.objects((T.self as! Object.Type).self).filter(filter!)
        }
        else {
                 
            results = defaultRealm.objects((T.self as! Object.Type).self)
        }
        
        guard results.count > 0 else { return [] }
        var objectArray = [T]()
        for model in results{
           objectArray.append(model as! T)
        }
       
        return objectArray
        
    }
    
    
}

/// 更新
extension RealmHelper {
    
    
    ///更新单条数据
    public class func updateObject<T>(object: T) {
        
        do {
            let defaultRealm = self.getDB()
            try defaultRealm.write {
                defaultRealm.add(object as! Object, update: .error)
            }
        }catch{}
    }
    
    
    
    /// 更新多条数据
    public class func updateObjects<T>(objects : [T]) {
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.add(objects as! [Object], update: .error)
        }
    }
    
    /// 更新多条数据的某一个属性
    public class func updateObjectsAttribute<T>(objectClass : T ,attribute:[String:Any]) {
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            let objects = defaultRealm.objects((T.self as! Object.Type).self)
            let keys = attribute.keys
             for keyString in keys {
                objects.setValue(attribute[keyString], forKey: keyString)
            }
        }
    }
    
}
