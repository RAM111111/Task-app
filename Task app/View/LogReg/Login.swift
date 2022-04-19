//
//  Login.swift
//  Task app
//
//  Created by R on 24/07/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
class Login: UIViewController {
    
    let spinner = JGProgressHUD(style: .dark)
    
    
    let scroll:UIScrollView = {
        let vi = UIScrollView()
        vi.layer.borderWidth = 1
        vi.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        return vi
    }()
    
    let emaileTF:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Address ..."
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 7
        tf.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        tf.layer.borderWidth = 1
        return tf
    }()
    
    let passwordTF:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password..."
        tf.isSecureTextEntry = true
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 7
        tf.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        tf.layer.borderWidth = 1
        return tf
    }()
    
    let loginBTN:UIButton = {
        let btn = UIButton()
        btn.setTitle("LogIn", for: .normal)
        btn.addTarget(self, action: #selector(btntapped), for: .touchUpInside)
        btn.layer.cornerRadius = 7
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        btn.backgroundColor = .purple
        return btn
    }()
    
    let viewS:UIStackView = {
        let btn = UIStackView()
        btn.axis = .horizontal
        btn.distribution = .fillProportionally
        return btn
    }()
    
    let lbl:UILabel = {
        let lbl = UILabel()
        lbl.contentHuggingPriority(for: .horizontal)
        lbl.text = "Don’t have an account ?  "
        lbl.textAlignment = .right
        return lbl
    }()
    
    let RegBTN:UIButton = {
        let btn = UIButton()
        btn.contentHorizontalAlignment = .leading
        btn.setTitle(" Create New", for: .normal)
        btn.addTarget(self, action: #selector(regView), for: .touchUpInside)
        btn.setTitleColor(UIColor.init("64B9FC"), for: .normal)
        return btn
    }()
    
    let viewStack:UIStackView = {
        let btn = UIStackView()
        btn.axis = .vertical
        btn.spacing = 8
        btn.distribution = .fillEqually
        return btn
    }()
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.cornerRadius = 7
        gradient.zPosition = -1
        gradient.type = .axial
        gradient.colors = [
            UIColor.init("A3E440").cgColor,
            UIColor.init("64B9FC").cgColor
        ]
        gradient.frame = loginBTN.bounds
        gradient.locations = [0.0, 1.0]
        return gradient
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = self.loginBTN.bounds
        self.loginBTN.layer.insertSublayer(gradient, at: 0)
        
    }
    @objc func regView(){
        print("uuuu")
        navigationController?.pushViewController(RegisterVC(), animated: true)
    }
    
    func setupView(){
        //        let con = lbl.widthAnchor.constraint(equalToConstant: 100)
        //        print(con.priority)
        //        con.priority = UILayoutPriority(rawValue: 999)
        //        con.isActive = true
        viewStack.addArrangedSubview(emaileTF)
        viewStack.addArrangedSubview(passwordTF)
        viewStack.addArrangedSubview(loginBTN)
        viewS.addArrangedSubview(lbl)
        viewS.addArrangedSubview(RegBTN)
        viewStack.addArrangedSubview(viewS)
        
        
        
        view.addSubview(scroll)
        scroll.addSubview(viewStack)
        
        scroll.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        viewStack.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 300, height: 250), centerY:view.centerYAnchor,centerX:view.centerXAnchor)
        
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        let vc =  ViewController()
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true)
//        let appDelegate = UIApplication.shared.delegate as! SceneDelegate
//        appDelegate.window?.rootViewController!.present(nav, animated: true, completion: nil)
//
//    }
    
    @objc func btntapped(){
        emaileTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
        guard let email =  emaileTF.text,!email.isEmpty,
            let password =  passwordTF.text,!password.isEmpty,password.count > 6 else{
                //                loginerrorr()
                return
        }
        spinner.show(in: view)
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self](_, err) in
            guard let selfstrong = self else {
                return
            }
            DispatchQueue.main.async {
                selfstrong.spinner.dismiss()
            }
            guard err == nil else{
                print("err")
                return
            }
            let safeEmail = DBM.safeemail(email: email)
            DBM.shared.getdataFor(for: safeEmail) {(res) in
                switch res{
                case .success(let data):
                    guard let userdata = data as? [String:Any] ,
                        let firstName = userdata["firstName"] as? String,
                        let lastName = userdata["lastName"] as? String else {
                            return
                    }
                    UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
                    UserDefaults.standard.set(safeEmail, forKey: "email")
                    let vc =  ViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    UIApplication.shared.windows.first?.rootViewController = ViewController()
                    UIApplication.shared.windows.first?.makeKeyAndVisible()

                case .failure(let err):
                    print("err to getdataFor\(err)")
                }


            }


            
        }
    }
}

