//
//  TaskModel.swift
//  Task app
//
//  Created by R on 24/07/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import UIKit


struct Task1 {
    let name:String
    let description:String
    let color:Int
    let time:Date
}
struct Tasks {
    let task:Task
    let id : String
}
struct Task {
    let name:String
    let description:String
    let color:UIColor
    let time:Date
}

struct Users {
        let firstName:String
        let lastName:String
        let email:String
        
        var safeEmail:String{
            var editEmail = email.replacingOccurrences(of: ".", with: "-")
            editEmail = editEmail.replacingOccurrences(of: "@", with: "-")
            return editEmail
        }
}
