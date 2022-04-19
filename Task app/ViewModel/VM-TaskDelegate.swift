//
//  VM-TaskDelegate.swift
//  Task app
//
//  Created by R on 24/08/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//
import RxSwift
import RxCocoa

extension taskviewmodel:TaskDelegate{
    func onTodoItemGet() {
                DBM.shared.getAllTasks(completion: { (res) in
            switch res{
            case .success(let Task):
                print("Get All Tasks successfully!")
                self.allDayTask.val = Task.map({ (arg) -> Tasks in
                    let (key, value) = arg
                    return Tasks(task: self.value(value: value), id: key)
                })
                if self.indexpathSelected == nil{
                    self.allDayTask.val =   (self.allDayTask.val.filter({self.dateToString(date: $0.task.time, format: "MMM d, yyyy") == self.dateToString(date: Date(), format: "MMM d, yyyy")}))
                }else{
                    self.allDayTask.val =   (self.allDayTask.val.filter({self.dateToString(date: $0.task.time, format: "MMM d, yyyy") == self.dateToString(date: self.weak.val[self.indexpathSelected!], format: "MMM d, yyyy")}))
                }
                self.allDayTask.val.sort { (a, b) -> Bool in
                    return a.task.time < b.task.time
                }
            case .failure(let error):
                print("getAllTasks err: \(error)")
            }
            
        })
    }
    //MARK:- onTaskDelete func
    //Func Delete specific Item...
    func onTaskDelete(key: String) {
          DBM.shared.deleteTask(with:key)
    }

    //MARK:- onTodoItemAded func
    //Func Add new Item...
    func onTodoItemAded() {
        guard let newTask = newTask else{return}
         DBM.shared.insertTask(with: newTask) { (successful) in
            if successful{
                print("Item Added Successfully..!")
                
            }else{
                print("Item Added Failure..!")
            }
        }
    }
}
