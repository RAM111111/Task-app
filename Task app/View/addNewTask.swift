//
//  addNewTask.swift
//  Task app
//
//  Created by R on 24/07/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import UIKit

class addNewTask: UIViewController {
    let viewModel = taskviewmodel()
    weak var delegate: TaskProtocol?
    var color = 0
    let colorArray = [ 0x000000, 0xfe0000, 0xff7900, 0xffb900, 0xffde00, 0xfcff00, 0xd2ff00, 0x05c000, 0x00c0a7, 0x0600ff, 0x6700bf, 0x9500c0, 0xbf0199, 0xffffff ]
    //MARK:- Outlet
    let container:UIView = {
        let vi = UIView()
        vi.layer.shadowColor = UIColor.lightGray.cgColor
        vi.layer.shadowOpacity = 0.5
        vi.backgroundColor = .white
        vi.layer.shadowOffset = .zero
        vi.layer.shadowRadius = 1
        vi.layer.cornerRadius = 25
        return vi
    }()
    lazy var tasskDescriptionTF: UITextView = {
        let textView: UITextView = UITextView()
        textView.layer.masksToBounds = true
        textView.text = "Task Description.."
        textView.textColor = UIColor.lightGray
        textView.layer.cornerRadius = 7
        textView.layer.borderWidth = 1
        textView.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        textView.font = UIFont.systemFont(ofSize: 16.0)
        textView.textAlignment = NSTextAlignment.left
        textView.dataDetectorTypes = UIDataDetectorTypes.all
        textView.layer.shadowOpacity = 0.5
        textView.isEditable = true
        return textView
    }()
    let taskNameTF:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Task Name..."
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 7
        tf.layer.borderColor =  .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        tf.layer.borderWidth = 1
        return tf
    }()
    let tasskDate:UIDatePicker = {
        let tf = UIDatePicker()
        tf.layer.cornerRadius = 7
        tf.layer.borderColor =  .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        tf.layer.borderWidth = 1
        return tf
    }()
    let slider:UISlider = {
        let slider = UISlider()
        slider.maximumValue = 13.5
        slider.minimumValue = 0.5
        slider.value = 13.5
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.layer.zPosition = 100
        slider.addTarget(self, action: #selector(valuechanged), for: .valueChanged)
        return slider
    }()
    let colorIMG:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "color")
        img.layer.borderColor =  .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        img.layer.borderWidth = 1
        img.layer.fillMode = .forwards
        return img
    }()
    let tasskAddbtn:UIButton = {
        let tf = UIButton()
        tf.layer.cornerRadius = 7
        tf.setTitle("ADD", for: .normal)
        tf.titleLabel?.textColor = .black
//        tf.backgroundColor =
        tf.addTarget(self, action: #selector(add), for: .touchUpInside)
        return tf
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
        gradient.frame = tasskAddbtn.bounds
        gradient.locations = [0.0, 1.0]
        return gradient
    }()
    let tasskCancelbtn:UIButton = {
        let tf = UIButton()
        tf.setTitle("Cancel", for: .normal)
        tf.setTitleColor(.blue, for: .normal)
        tf.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return tf
    }()
    let scroll:UIScrollView = {
        let vi = UIScrollView()
        vi.contentSize = CGSize(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height - 300)
        return vi
    }()
    //MARK:- View
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "add Task"
        setupView()
        tasskDescriptionTF.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = self.tasskAddbtn.bounds
        self.tasskAddbtn.layer.insertSublayer(gradient, at: 0)
    }
    //MARK:- Func setupView
    func setupView(){
        view.addSubview(scroll)
        scroll.addSubview(container)
        scroll.anchor(top: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,centerY: view.centerYAnchor,centerX: view.centerXAnchor)
        container.anchor(top: scroll.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: UIEdgeInsets(top:60, left: 0, bottom: 0, right: 0),size: CGSize(width: 350, height: 500),centerX: scroll.centerXAnchor)
        container.addSubview(taskNameTF)
        container.addSubview(tasskDescriptionTF)
        container.addSubview(tasskDate)
        container.addSubview(slider)
        container.addSubview(colorIMG)
        container.addSubview(tasskAddbtn)
        container.addSubview(tasskCancelbtn)
        taskNameTF.anchor(top: container.topAnchor, leading: nil, bottom: nil, trailing: nil,padding: UIEdgeInsets(top:32, left: 0, bottom: 0, right: 0), size: CGSize(width: 250, height: 50),centerX: container.centerXAnchor)
        tasskDescriptionTF.anchor(top:taskNameTF.bottomAnchor , leading: nil, bottom: nil, trailing: nil,padding: UIEdgeInsets(top:18, left: 0, bottom: 0, right: 0),size: CGSize(width: 250, height: 100), centerX: container.centerXAnchor)
        tasskDate.anchor(top:tasskDescriptionTF.bottomAnchor , leading:nil, bottom: nil, trailing: nil,padding: UIEdgeInsets(top:18, left: 0, bottom: 0, right: 0),size: CGSize(width: 250, height: 100), centerX: container.centerXAnchor)
        colorIMG.anchor(top:tasskDate.bottomAnchor , leading:nil, bottom: nil, trailing: nil,padding: UIEdgeInsets(top:18, left: 0, bottom: 0, right: 0),size: CGSize(width: 250, height: 5), centerX: container.centerXAnchor)
        slider.anchor(top:nil, leading:colorIMG.leadingAnchor, bottom: nil, trailing: colorIMG.trailingAnchor,centerY: colorIMG.centerYAnchor)
        tasskAddbtn.anchor(top:colorIMG.bottomAnchor , leading:nil, bottom: nil, trailing: nil,padding: UIEdgeInsets(top:18, left: 0, bottom: 0, right: 0),size: CGSize(width: 250, height: 50), centerX: container.centerXAnchor)
        tasskCancelbtn.anchor(top:tasskAddbtn.bottomAnchor , leading:nil, bottom: nil, trailing: nil,padding: UIEdgeInsets(top:18, left: 0, bottom: 0, right: 0),size: CGSize(width: 250, height: 50), centerX: container.centerXAnchor)
    }
    //MARK:- Func valuechanged:Slider Target
    @objc func valuechanged(sender:UISlider){
        color = colorArray[Int(slider.value)]
        slider.thumbTintColor = taskviewmodel().uiColorFromHex(rgbValue: colorArray[Int(slider.value)])
    }
    //MARK:- Func cancel
    @objc func cancel(){
        dismiss(animated: true, completion: nil)
    }
    //MARK:- Func Add:Button Target
    @objc func add(){
        if let name = taskNameTF.text,let des = tasskDescriptionTF.text ,!name.isEmpty,!des.isEmpty{
            let task = Task1( name: name, description: des, color: color, time: tasskDate.date)
            viewModel.newTask = task
            viewModel.onTodoItemAded()
            dismiss(animated: true, completion: nil)
        }
    }
}
//MARK:- Func extension
extension addNewTask: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !tasskDescriptionTF.text!.isEmpty && tasskDescriptionTF.text! == "Task Description.." {
            tasskDescriptionTF.text = ""
            tasskDescriptionTF.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if tasskDescriptionTF.text.isEmpty {
            tasskDescriptionTF.text = "Task Description.."
            tasskDescriptionTF.textColor = UIColor.lightGray
        }
    }
}
