//
//  TaskCell.swift
//  Task app
//
//  Created by R on 21/07/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    //MARK:- Variables
    static let identifier = "TaskCell"
    //MARK:- Outlet
    let TaskName:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    let TaskDescription:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .light)
        lbl.numberOfLines = 0
        return lbl
    }()
    let TaskTime:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .ultraLight)
        return lbl
    }()
    let TaskButtonCheck:UIButton = {
        let lbl = UIButton()
        lbl.layer.cornerRadius = 6
        lbl.backgroundColor = .black
        return lbl
    }()
    let TaskColor:UIView = {
        let lbl = UIView()
        lbl.layer.cornerRadius = 2.5
        lbl.backgroundColor = .black
        return lbl
    }()
    let container:UIView = {
        let vi = UIView()
        vi.layer.cornerRadius = 7
        vi.layer.borderWidth = 1
        vi.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        return vi
    }()
    //MARK:- View
    override func awakeFromNib(){
        super.awakeFromNib()
        contentView.addSubview(container)
        container.addSubview(TaskName)
        container.addSubview(TaskDescription)
        container.addSubview(TaskTime)
        container.addSubview(TaskColor)
        container.addSubview(TaskButtonCheck)
        TaskButtonCheck.frame = CGRect(x: 10, y: 10, width:12, height:12)
        container.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor,padding:UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8) )
        TaskName.anchor(top: container.topAnchor, leading: TaskButtonCheck.trailingAnchor, bottom: nil, trailing: TaskTime.leadingAnchor,padding:UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8))
        TaskDescription.anchor(top: TaskName.bottomAnchor, leading: TaskColor.trailingAnchor, bottom: container.bottomAnchor, trailing: container.trailingAnchor,padding:UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8))
        TaskTime.anchor(top: container.topAnchor, leading: nil, bottom: nil, trailing: container.trailingAnchor,size: CGSize(width: 50, height: 50))
        TaskColor.anchor(top: TaskButtonCheck.bottomAnchor, leading: container.leadingAnchor, bottom: container.bottomAnchor, trailing: nil,padding: UIEdgeInsets(top: 8, left: 12.5, bottom: 8, right: 0),size: CGSize(width: 5, height: 0))
    }
    //MARK:- configure
    func configure(task:Task){
        TaskName.text = task.name
        TaskDescription.text = task.description
        TaskTime.text = taskviewmodel().dateToString(date: task.time, format: "HH:mm")
        TaskColor.backgroundColor = task.color
        TaskButtonCheck.backgroundColor = task.color
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
