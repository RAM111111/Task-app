//
//  takViewModel.swift
//  Task app
//
//  Created by R on 19/07/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD

extension BehaviorRelay {
    var val: Element {
        get { value }
        set { accept(newValue) }
    }
}
//MARK:- TaskData pro
// Task Data
protocol TaskData{
    var id:String? { get}
    var name:String? {get}
    var color:Bool? {get set}
    var time:String? {get}
    var description :String? {get}
}
//MARK:- TaskDelegate pro
// Task Delegate
protocol TaskDelegate :class{
    func onTodoItemAded()->()
    func onTodoItemGet()->(Void)
    func onTaskDelete(key:String)
}


class taskviewmodel{
    var newTask:Task1?
    var collectionIndexPath:IndexPath?
    var weak:BehaviorRelay<[Date]> = BehaviorRelay(value: [])
    var allTask:BehaviorRelay<[String:[String:Any]]>?
    var allDayTask:BehaviorRelay<[Tasks]> = BehaviorRelay(value:[])
    let dateFormatter = DateFormatter()
    var day:String? = "\(Date())"
    var indexpathSelected:Int?
    init() {
}

}




