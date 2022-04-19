//
//  Validate.swift
//  Task app
//
//  Created by R on 17/09/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import UIKit
import FirebaseAuth
import Network


class Validate: UIViewController {
    let monitor = NWPathMonitor()
    var connected:Bool?
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.cornerRadius = 7
        gradient.zPosition = -1
        gradient.type = .axial
        gradient.colors = [
            UIColor.init("A3E440").cgColor,
            UIColor.init("64B9FC").cgColor
        ]
        gradient.locations = [0.0, 1.0]
        return gradient
    }()
    let logoIMG:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.tintColor = .white
        img.image  = UIImage(systemName: "star")
        return img
    }()
    let logoLbl:UITextView = {
        let img = UITextView()
        img.text = "Task App"
        img.textColor = .white
        img.backgroundColor = .clear
        img.textAlignment = .center
        img.font = UIFont.boldSystemFont(ofSize: 36)
        return img
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoIMG)
        logoIMG.frame = CGRect(x: view.width / 2 - 100, y: view.height / 2 - 150, width: 200, height: 200)
        view.addSubview(logoLbl)
        logoLbl.frame = CGRect(x: view.width / 2 - 100, y: logoIMG.bottom - 10, width: 200, height: 50)
        monitor.pathUpdateHandler = { path in
           if path.status == .satisfied {
              print("Connected")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                    if Auth.auth().currentUser == nil{
                            let nav = UINavigationController(rootViewController: Login())
                            nav.modalPresentationStyle = .fullScreen
                            UIApplication.shared.windows.first?.rootViewController = nav
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
                    }else{

            let nav = UINavigationController(rootViewController: ViewController())
                        nav.modalPresentationStyle = .fullScreen
                        nav.navigationBar.isHidden = true
                        UIApplication.shared.windows.first?.rootViewController = ViewController()
                        
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                }}
           } else {
              print("Disconnected")
            DispatchQueue.main.async {
                            self.showToast(message: "No Internet Connection", seconds: 3.0)

            }
           }
           print(path.isExpensive)
        }
        monitor.start(queue: DispatchQueue.init(label: "Validate"))
        monitor.cancel()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
