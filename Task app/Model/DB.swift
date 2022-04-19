//
//  DB.swift
//  Task app
//
//  Created by R on 02/08/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase
//MARK: - DatabaseManager
final class DBM{
    static let shared = DBM()
    private let database = Database.database().reference()
    }

extension DBM:TaskDB{
    //MARK: - userExist func
    public func userExist(with email:String,completion:@escaping((Bool)->Void)){
        var editEmail = email.replacingOccurrences(of: ".", with: "-")
        editEmail = editEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(editEmail).observeSingleEvent(of: .value) { snapshoot in
            guard  snapshoot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    //MARK: - insertUser func
    public func insertUser(with user:Users,complition:@escaping(Bool)->Void){
        let userData:[String:[String:String]] = ["profile":
            ["firstName":user.firstName,
             "lastName":user.lastName,
             "email":user.email]]
        database.child(user.safeEmail).setValue(userData) { (err, _) in
            guard  err == nil else{
                print("Failure insert User")
                complition(false)
                return
            }
            print("success insert User")
            complition(true)
            
            
        }
    }
    //MARK: - getAllTasks func
    public func getAllTasks(completion:@escaping(Result<[String:[String:Any]],Error>)->Void){
//        ,deletion:@escaping(String)->Void,
//        added:@escaping([String:[String:Any]])->Void)
//    {
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        database.child("\(email)/tasks").observe(.value, with: { (snapshoot) in
            guard let value = snapshoot.value as? [String:[String:Any]] else{
                completion(.failure(errors.getAllUsersOnlinFailure))
                return
            }
            completion(.success(value))
        })
//        database.child("\(email)/tasks").observe(.childRemoved, with: { (snapshoot) in
//            guard let value = snapshoot.value as? String else{
////                completion(.failure(errors.getAllUsersOnlinFailure))
//                print("err delete")
//                return
//            }
//            deletion(value)
//        })
//
//        database.child("\(email)/tasks").observe(.childAdded, with: { (snapshoot) in
//                    guard let value = snapshoot.value as?  [String:[String:Any]]  else{
//        //                completion(.failure(errors.getAllUsersOnlinFailure))
//                        print("err delete")
//                        return
//                    }
//                    added(value)
//                })
        
    }
            
    //MARK: - insertTask func
    public func insertTask(with task:Task1,complition:@escaping(Bool)->Void){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        database.child("\(email)/tasks").observeSingleEvent(of: .value) { (snapshoot) in
            guard var newtask = snapshoot.value as? [String:[String:Any]] else {
                let newtask = ["\(UUID())":
                    ["Name":task.name,
                     "Description":task.description,
                     "Color":task.color,
                     "Time":"\(task.time)"]]
                self.database.child("\(email)/tasks").setValue(newtask) { (err, _) in
                    guard err == nil else {
                        print("setValue Failure")
                        complition(false)
                        return
                    }
                    complition(true)
                    print("setValue successfully")
                }
                return
            }
            newtask["\(UUID())"] = ["Name":task.name,
                                    "Description":task.description,
                                    "Color":task.color,
                                    "Time":"\(task.time)"]
            self.database.child("\(email)/tasks").setValue(newtask) { (err, _) in
                guard err == nil else {
                    print("setValue Failure")
                    complition(false)
                    return
                }
                complition(true)
                print("setValue successfully")
            }
        }
        
    }
    
    //MARK: - deletetask func
    public func deleteTask(with name:String){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        database.child("\(email)/tasks").child(name).removeValue {(err, _) in
            guard err == nil else{
                print("Task Deleted Failure! ")
                return
            }
            print("Task Deleted Successfully!... ")
        }
    }
    
    //MARK: - getdataFor func
    public func getdataFor(for path:String,complition:@escaping (Result<Any,Error>)->Void){

        database.child("\(path)/profile").observeSingleEvent(of: .value) { (snapshoot) in
            guard let value = snapshoot.value else{
                complition(.failure(DataBaseError.feildToFetch))
                print("Get getdataFor Failure!... ")
                
                return
            }
            complition(.success(value))
            print("Get getdataFor Successfully!... ")
            
        }
    }
    //MARK: - subscribe func
//    func subscribe(completion: @escaping ([String : Any]) -> Void,deletion: @escaping ([String : Any]) -> Void) {
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return
//        }
//        database.collection(email).addSnapshotListener { (snapshoot, err) in
//            guard let collection = snapshoot else {return}
//            collection.documentChanges.forEach { (change) in
//                    if change.type == .added{
//                        let item = change.document.data()
//                        completion(item)
//                    }
//                if change.type == .modified{
//                    let item = change.document.data()
//                    completion(item)
//                }
//                if change.type == .removed{
//                    let item = change.document.data()
//                    deletion(item)
//                }
//
//            }
//
//        }
//    }
    
    //MARK: - safeemail func
    static func safeemail(email:String)->String{
        var editEmail = email.replacingOccurrences(of: ".", with: "-")
        editEmail = editEmail.replacingOccurrences(of: "@", with: "-")
        return editEmail
    }
    
    
    
    public enum DataBaseError:Error{
        case feildToFetch
    }
    
    public enum errors:Error{
        case getAllUsersOnlinFailure
    }
    
}
