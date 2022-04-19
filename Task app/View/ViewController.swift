//
//  ViewController.swift
//  Task app
//
//  Created by R on 19/07/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    //MARK:- Variables
    let spinner = JGProgressHUD(style: .dark)
    let spinnerIMG = JGProgressHUD(style: .extraLight)
    var allTask1 = [(key: String, value: [String : Any])]()
    var taskFilter = [Task]()
    var indexNUM = 0
    var taskID = [String]()
    let dateFormatter = DateFormatter()
    var viewModel:taskviewmodel? = taskviewmodel()
    
    var  disposeBag = DisposeBag()
    var  disposeBag1 = DisposeBag()
    
    //MARK:- Outlet
    let headerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let imageView:UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .cyan
        img.layer.borderColor = UIColor.lightGray.cgColor
        img.layer.borderWidth = 4
        img.image = UIImage(named: "profile")
        img.clipsToBounds = true
        img.layer.cornerRadius = 35
        return img
    }()
    let emptyimageView:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "empty")
        img.clipsToBounds = true
        return img
    }()
    let emptymessage:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textColor = .lightGray
        lbl.textAlignment = .center
        lbl.text = "Empty!.. write New Task."
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let nameLabel:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        return lbl
    }()
    let dateLabel:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textColor = .gray
        return lbl
    }()
    let dateList:UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.scrollDirection = .horizontal
        let list = UICollectionView(frame:CGRect(x: 0, y: 130, width: 400, height: 60), collectionViewLayout:layout)
        list.register(WeakDateCell.self, forCellWithReuseIdentifier: WeakDateCell.identifier)
        list.backgroundColor = .white
        list.showsHorizontalScrollIndicator = false
        return list
    }()
    let taskList:UITableView = {
        let tbl = UITableView()
        tbl.backgroundColor = .white
        tbl.separatorStyle = .none
        tbl.register(TaskCell.self, forCellReuseIdentifier:TaskCell.identifier)
        return tbl
    }()
    let btn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = nil
        btn.tintColor = .white
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.addTarget(self, action: #selector(addTask), for: .touchUpInside)
//        btn.layer.borderWidth = 1.5
        btn.layer.cornerRadius = 7
//        btn.layer.borderColor = UIColor.purple.cgColor
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
            gradient.frame = btn.bounds
            gradient.locations = [0.0, 1.0]
            return gradient
        }()
    //MARK:- ViewWillAppear:Update
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.onTodoItemGet()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validate()
    }
    //MARK:- Viewdidload:startView
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn.layer.insertSublayer(gradient, at: 0)
        viewModel?.fetchcurrentweak()
        setupData()
        setUpViews()
        viewModel?.updateProfilIMG(img:imageView,lbl:nameLabel, spinnerIMG:spinnerIMG)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = self.btn.bounds
    }
    //MARK:- validate:Check if there User Login
    func validate(){
        print("validate")
        if Auth.auth().currentUser == nil{
            present((viewModel?.LoginView())!, animated: false)
            self.dismiss(animated: true, completion: nil)

        }else{
            
        }
    }

    //MARK:- setupData:DataSource & Delegate for VC
    func setupData(){
        taskList.delegate = nil
        taskList.dataSource = nil
        disposeBag = DisposeBag()
        disposeBag1 = DisposeBag()
        
        //        taskList.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel?.weak.bind(to: dateList.rx.items(cellIdentifier: WeakDateCell.identifier, cellType: WeakDateCell.self)){index,item,cell in
            cell.configure(day: item)
        }.disposed(by: disposeBag)
        
        dateList.rx.itemSelected.bind {[weak self] (indexpath) in
            self?.viewModel?.indexpathSelected = indexpath.item
            self?.viewModel?.onTodoItemGet()
        }.disposed(by: disposeBag)
        
        
        viewModel?.allDayTask.asObservable()
            .filter({ [weak self] array in
                guard let self = self else {return true}
                
                if array.isEmpty {
                    print("tru")
                    self.taskList.alpha = 0
                    self.emptymessage.alpha = 1
                    self.emptyimageView.alpha = 1
                    
                            }else{
                    print("fal")
                    self.taskList.alpha = 1
                    self.emptymessage.alpha = 0
                    self.emptyimageView.alpha = 0
                            }
                return true
            })
          .bind(to: taskList.rx.items(cellIdentifier: TaskCell.identifier, cellType: TaskCell.self)){index,item,cell in
                cell.awakeFromNib()
                cell.configure(task:item.task)
                print("item",item)
            }.disposed(by: disposeBag1)

        taskList.rx.itemDeleted
            .subscribe(onNext:
                {
                    print($0.row)
                    self.viewModel?.onTaskDelete(key: (self.viewModel?.allDayTask.val[$0.row].id)!)
            }).disposed(by: disposeBag1)
    }
    
    //MARK:- Func setUpViews: Views for VC
    func setUpViews(){
        print("setUpViews")
        view.backgroundColor = .white
        
        taskList.estimatedRowHeight = taskList.rowHeight
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        headerView.isUserInteractionEnabled = true
        headerView.isUserInteractionEnabled = true
        headerView.addGestureRecognizer(gesture)
        
        view.addSubview(headerView)
        view.addSubview(dateList)
        view.addSubview(emptymessage)
        view.addSubview(emptyimageView)
        view.addSubview(taskList)


        taskList.estimatedRowHeight = 100;
        taskList.rowHeight = UITableView.automaticDimension;
        headerView.addSubview(imageView)
        headerView.addSubview(nameLabel)
        headerView.addSubview(dateLabel)
        headerView.addSubview(btn)

        
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: UIEdgeInsets(top: 32, left: 16, bottom: 16, right: 16),size: CGSize(width: 0, height: 80))
        imageView.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: nil, trailing: nil,size: CGSize(width: 70, height: 70))
        nameLabel.anchor(top: headerView.topAnchor, leading: imageView.trailingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),size: CGSize(width: 200, height: 30))
        btn.anchor(top: nil, leading: nil, bottom: nil, trailing: headerView.trailingAnchor,size: CGSize(width: 45, height: 45),centerY: headerView.centerYAnchor)
        dateLabel.anchor(top: nameLabel.bottomAnchor, leading: imageView.trailingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8),size: CGSize(width: 200, height: 30))
        dateLabel.frame = CGRect(x:imageView.right + 16, y: nameLabel.bottom, width: 200, height: 30)
        taskList.anchor(top: dateList.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        dateList.frame.size.width = view.width
        dateList.anchor(top: headerView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,size: CGSize(width: 0, height: 80))
        dateLabel.text = taskviewmodel().dateToString(date: Date(), format: "MMM d, yyyy")
        emptyimageView.frame = CGRect(x:view.width / 2 - 50 , y:view.height / 2 - 50, width: 100, height: 100)
        emptymessage.frame = CGRect(x:view.width / 2 - 100, y:emptyimageView.bottom + 10, width:  200, height: 20)
    }
    //MARK:- Func addTask: Go to addNewTask VC
    @objc func addTask(){
        print("addTask")
        let addnewtask = addNewTask()
        let nav = UINavigationController(rootViewController: addnewtask)
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true)
        print("pressed")
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        let vc =  Login()
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true)
//        let appDelegate = UIApplication.shared.delegate as! SceneDelegate
//        appDelegate.window?.rootViewController!.present(vc, animated: true, completion: nil)
//    }
    //MARK:- imgTapped
    @objc func imgTapped(){
        print("imgTapped")
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want sign out...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self](action) in
            guard let self = self else {return}
            if (self.viewModel?.signOut())!{
                let nav = UINavigationController(rootViewController: Login())
                nav.modalPresentationStyle = .fullScreen
                UIApplication.shared.windows.first?.rootViewController = nav
                UIApplication.shared.windows.first?.makeKeyAndVisible()
                
            }
            print("imgTapped signOut")
            
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(alert,animated: true)
    }
}
