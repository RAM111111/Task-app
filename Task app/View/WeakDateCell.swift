//
//  WeakDateCell.swift
//  Task app
//
//  Created by R on 21/07/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import UIKit

class WeakDateCell: UICollectionViewCell {
    static let identifier = "WeakDateCell"
    
    let dayNum:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .gray
        lbl.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .light)
        return lbl
    }()
    let dayName:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .gray
        lbl.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .bold)
        return lbl
    }()
    let container:UIView = {
        let vi = UIView()
        vi.layer.cornerRadius = 7
        return vi
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
        gradient.locations = [0, 1]
        return gradient
    }()
    lazy var gradient2: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.cornerRadius = 7
        gradient.zPosition = -1
        gradient.type = .axial
        gradient.colors = [
            UIColor.white.cgColor,
            UIColor.white.cgColor
        ]
        gradient.locations = [0, 1]
        return gradient
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(container)
        container.frame = CGRect(x: 0, y: 0, width: contentView.width - 8, height: contentView.height - 8)
        dayName.frame = CGRect(x: 0, y: container.top, width: container.width, height: container.height / 2)
        dayNum.frame = CGRect(x: 0, y: dayName.bottom, width: container.width , height: container.height / 2)
        container.addSubview(dayNum)
        container.addSubview(dayName)
    }
    
    func configure(day:Date){
        if taskviewmodel().dateToString(date: day, format: "dd") == taskviewmodel().dateToString(date: Date(), format: "dd"){
            container.backgroundColor = UIColor.init("64B9FC")
            dayNum.textColor = .white
            dayName.textColor = .white
        }
        
        dayNum.text = taskviewmodel().dateToString(date: day, format: "dd")
        dayName.text  = taskviewmodel().dateToString(date: day, format: "EEE")
    }
    override var isSelected: Bool {
        didSet {
            container.backgroundColor = self.isSelected ? UIColor.init("64B9FC") : .clear
            dayName.textColor = self.isSelected ? .white : .gray
            dayNum.textColor = self.isSelected ? .white : .gray
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

