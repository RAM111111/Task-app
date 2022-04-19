//
//  TaskDB.swift
//  Task app
//
//  Created by R on 18/08/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import Foundation
protocol TaskDB {
     func userExist(with email:String,completion:@escaping((Bool)->Void))
     func insertUser(with user:Users,complition:@escaping(Bool)->Void)
     func getAllTasks(completion:@escaping(Result<[String:[String:Any]],Error>)->Void)
     func insertTask(with task:Task1,complition:@escaping(Bool)->Void)
}
