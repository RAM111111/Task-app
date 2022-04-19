//
//  VM-TaskDatafunc.swift
//  Task app
//
//  Created by R on 24/08/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import RxSwift
import RxCocoa

extension taskviewmodel{
    //MARK:- fetchcurrentweak func
    //Func To Fetch Current weak start with Sun
    func fetchcurrentweak(){
        weak = BehaviorRelay(value: [])
        let today = Date()
        let callender = Calendar.current
        let weaks = callender.dateInterval(of: .weekOfMonth, for: today)
        if let firstweakday = weaks?.start {
            for i in 0...6{
                if let weakday = callender.date(byAdding: .day, value: i, to: firstweakday){
                    weak.val.append(weakday)
                }}}}
    
    //MARK:- extradate func
    //Func To format date with given format
    func dateToString(date:Date,format:String)->String{
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    func stringToDate(date:String,format:String)->Date{
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date)!
    }
    //MARK:- Value func
    //Func convert value to Taskdate    String    "2022-03-23 22:31:02 +0000"
    func value(value:[String:Any]) -> Task{
        var task:Task?
        if let name = value["Name"] as? String ,
            let description = value["Description"] as? String,
            let color = value["Color"] as? Int,
            let time = value["Time"] as? String {
            task = Task(name: name, description: description, color: taskviewmodel().uiColorFromHex(rgbValue: color), time: stringToDate(date: time, format: "yyyy-MM-dd' 'HH:mm:ss Z"))
        }
        return task!
    }
    //MARK:- uiColorFromHex func
    //Func convert Int to color
    func uiColorFromHex(rgbValue: Int) -> UIColor {
        let red =   CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(rgbValue & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
