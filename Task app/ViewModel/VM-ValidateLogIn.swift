//
//  VM-ValidateLogIn.swift
//  Task app
//
//  Created by R on 24/08/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import UIKit
import FirebaseAuth

extension taskviewmodel{
    func LoginView() -> UINavigationController{
        print("LoginView")
        let vc =  Login()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        return nav
    }
    func signOut() -> Bool{
        do{
            try Auth.auth().signOut()
            print("Log Out")
            return true
        }catch{
            print("feild Log Out")
            return false
        }
    }
}
