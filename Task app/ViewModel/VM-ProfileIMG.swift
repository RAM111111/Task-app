//
//  VM-ProfileIMG.swift
//  Task app
//
//  Created by R on 24/08/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD

extension taskviewmodel{
    
    func updateProfilIMG(img:UIImageView,lbl:UILabel,spinnerIMG:JGProgressHUD){
        spinnerIMG.show(in: img)
        guard let name = UserDefaults.standard.value(forKey: "name") as? String,
            let ProfileImg = UserDefaults.standard.value(forKey: "Profile_img") as? String ,
            let email = UserDefaults.standard.value(forKey: "email") as? String else {
                return
        }
        lbl.text = name
        img.image = UIImage(named: ProfileImg)
        let safe = DBM.safeemail(email: email)
        let path = "images/\(safe).png"
        StorageManager.shared.downloadURl(path: path) {(res) in
            switch res{
            case .success(let url):
                URLSession.shared.dataTask(with: url) { (data, _, err) in
                    guard let data = data ,err == nil else {
                        return
                    }
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        spinnerIMG.dismiss()
                        img.image = image
                    }
                }.resume()
            case .failure(let err):
                print("er to get photo : \(err)")
            }
        }
    }
}
