//
//  ViewController.swift
//  RealmDemo
//
//  Created by admin on 2020/3/26.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // 像常规 Swift 对象一样使用
        let student = Student()
        student.name = "22222"
        student.age = 55
        student.id = 20
        
        let student1 = Student()
        student1.name = "555555"
        student1.age = 55
        student1.id = 21
        
        ///保存到数据库
//        RealmHelper.addObject(object: student)
      
        
        //查询某条数据
        let studentArray1 = RealmHelper.queryObject(objectClass: Student(),filter:"id = 20")
        let studentQuery = studentArray1.first
        print("*******\(studentQuery?.name ?? "")")
        
        //删除单条数据
        RealmHelper.deleteObject(object: studentQuery)
        if (studentQuery != nil) {
           
        }
       
        ///查询所有
        let studentArray = RealmHelper.queryObject(objectClass: Student())
        for stu in studentArray {
            print("*******\(stu.name)")
        }
        
        
    }


}

