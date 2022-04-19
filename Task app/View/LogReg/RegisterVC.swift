//
//  RegisterVC.swift
//  Task app
//
//  Created by R on 01/08/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterVC: UIViewController {
    
    let profileIMG:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 60
        img.layer.borderWidth = 2
        img.layer.borderColor = UIColor.lightGray.cgColor
        img.tintColor = .lightGray
        img.layer.masksToBounds = true
        img.layer.fillMode = .backwards
        img.image  = UIImage(systemName: "person.circle")
        return img
    }()
    
    let fNameTF:UITextField = {
        let tf = UITextField()
        tf.placeholder = "First Name"
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 7
        tf.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        tf.layer.borderWidth = 1
        return tf
    }()
    let lNameTF:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last Name"
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 7
        tf.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        tf.layer.borderWidth = 1
        return tf
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
        tf.placeholder = "Password  ..."
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
        btn.setTitle("Create Account", for: .normal)
        btn.addTarget(self, action: #selector(regesterUser), for: .touchUpInside)
        btn.layer.cornerRadius = 7
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        btn.backgroundColor = .purple
        return btn
    }()
    
    let viewStack:UIStackView = {
        let btn = UIStackView()
        btn.axis = .vertical
        btn.spacing = 8
        btn.distribution = .fillEqually
        return btn
    }()
    let scroll:UIScrollView = {
        let vi = UIScrollView()
        vi.contentSize = CGSize(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height - 300)
        return vi
    }()
    let viewS:UIStackView = {
        let btn = UIStackView()
        btn.axis = .horizontal
        btn.distribution = .fillProportionally
        return btn
    }()
    let mainview:UIView = {
        let btn = UIView()
        return btn
    }()
    
    
    let errMsgTF:UILabel = {
        let lbl = UILabel()
        //        lbl.contentHuggingPriority(for: .horizontal)
        lbl.textAlignment = .right
        return lbl
    }()
    
    let lbl:UILabel = {
        let lbl = UILabel()
        lbl.contentHuggingPriority(for: .horizontal)
        lbl.text = "Already have an account ?  "
        lbl.textAlignment = .right
        return lbl
    }()
    
    let RegBTN:UIButton = {
        let btn = UIButton()
        btn.contentHorizontalAlignment = .leading
        btn.setTitle("Log in", for: .normal)
        btn.addTarget(self, action: #selector(logInUser), for: .touchUpInside)
        btn.setTitleColor(UIColor.init("64B9FC"), for: .normal)
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
    @objc func logInUser(){
        navigationController?.popViewController(animated: true)
    }
    
    func setupView(){
        view.addSubview(scroll)
        //        scroll.addSubview(mainview)
        scroll.addSubview(viewStack)
        scroll.addSubview(profileIMG)
        
        viewStack.addArrangedSubview(fNameTF)
        viewStack.addArrangedSubview(lNameTF)
        viewStack.addArrangedSubview(emaileTF)
        viewStack.addArrangedSubview(passwordTF)
        viewStack.addArrangedSubview(loginBTN)
        viewStack.addArrangedSubview(viewS)
        viewStack.addArrangedSubview(errMsgTF)
        
        viewS.addArrangedSubview(lbl)
        viewS.addArrangedSubview(RegBTN)
        
        profileIMG.anchor(top: scroll.topAnchor, leading: nil, bottom:nil, trailing: nil,size: CGSize(width: 120, height: 120), centerX: scroll.centerXAnchor)
        scroll.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,centerX: view.centerXAnchor)
        //        mainview.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,centerX: view.centerXAnchor)
        
        
        viewStack.anchor(top: profileIMG.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0), size: CGSize(width: 300, height: 450), centerY:nil,centerX:scroll.centerXAnchor)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        profileIMG.isUserInteractionEnabled = true
        profileIMG.isUserInteractionEnabled = true
        profileIMG.addGestureRecognizer(gesture)
        
    }
    @objc func regesterUser(){
        guard let email = emaileTF.text,
            let firstName = fNameTF.text,
            let lastName = lNameTF.text,
            let password = passwordTF.text,
            !email.isEmpty,!password.isEmpty,!firstName.isEmpty,!lastName.isEmpty else{
                errMsgTF.text = "Complete all Information..."
                return
        }
        let user = Users(firstName: firstName, lastName: lastName, email: email)
        
        DBM.shared.userExist(with: email) { [weak self] (exist) in
            guard !exist else{
                print("email already exist")
                return
            }
            //MARK:-spinner.dismiss
            //            DispatchQueue.main.async {
            //                self?.spinner.dismiss()
            //            }
            
            //MARK:-createUser Auth
            Auth.auth().createUser(withEmail: email, password: password) {(authh, err) in
                guard  authh != nil,err == nil else{
                    print("err createUser")
                    return
                }
                //  let chatUser = family(email: email, firstName: firstName, lastName: lastName)
                //MARK:-insertUser Database
                DBM.shared.insertUser(with:user ,complition: {success in
                    if success{
                        let safeEmail = DBM.safeemail(email: email)
                        print("success Insert profile data")
                        UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
                        UserDefaults.standard.set(safeEmail, forKey: "email")
                    }else{
                        print("failure Insert profile data")
                        
                        
                    }
                    guard let img = self?.profileIMG.image,
                        let data = img.pngData() else {
                            return
                    }
                    let fileName = "\(user.safeEmail).png"
                    StorageManager.shared.uploudProfilPic(with: data,filename:fileName) {(result) in
                        print("uploudProfilPic func")
                        switch result{
                        case .success(let downloadUrl):
                            UserDefaults.standard.set(downloadUrl, forKey: "Profile_img")
                            print("uploudProfilPic success ")
                            print(downloadUrl)
                            UIApplication.shared.windows.first?.rootViewController = ViewController()
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                        case .failure(let error):
                            print("uploudProfilPic err: \(error)")
                        }
                        
                    }
                })


            }
        }
    }

    //MARK:-imgTapped func
    @objc private func imgTapped(){
        print("imgTapped func")
        presenrPhotoActionSheet()
    }
    
}

//MARK:-extension:UIImagePickerControllerDelegate,UINavigationControllerDelegate
extension RegisterVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func presenrPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How Would you like select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "close",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take a Photo",
                                            style: .default,
                                            handler: {[weak self]_ in
                                                self?.takePhoto()
        }))
        actionSheet.addAction(UIAlertAction(title: "choose a Photo",
                                            style: .default,
                                            handler: {[weak self]_ in
                                                self?.choosePhoto()
                                                
        }))
        present(actionSheet,animated: true)
        
        
    }
    func takePhoto(){
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .camera
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    func choosePhoto(){
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        present(vc,animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.profileIMG.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
