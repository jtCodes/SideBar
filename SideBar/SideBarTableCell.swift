//
//  SideBarTableCell.swift
//  SideBarTests
//
//  Created by J Tan on 10/22/18.
//  Copyright © 2018 J Tan. All rights reserved.
//

import Foundation
import SnapKit

let whiteThemeDict = ["replyToLink" : UIColor(red: 0.4863, green: 0, blue: 0.2275, alpha: 1.0),
                      "quote" : UIColor(red: 0.4706, green: 0.6, blue: 0.1333, alpha: 1.0),
                      "chanLink" : UIColor(red:0.90, green:0.08, blue:0.08, alpha:1.0),
                      "table" : UIColor.white, "cell" : UIColor.white, "com" : UIColor.black,
                      "name" : UIColor.green, "details" : UIColor.gray.withAlphaComponent(0.7),
                      "sub" : UIColor.black.withAlphaComponent(0.85)]

let darkThemeDict = ["navbar" : UIColor(red:0.16, green:0.16, blue:0.17, alpha:1.0),
                     "replyTo" : UIColor(red:0.19, green:0.27, blue:0.35, alpha:1.0),
                     "quote" : UIColor(red: 0.4706, green: 0.6, blue: 0.1333, alpha: 1.0),
                     "chanLink" : UIColor(red:0.31, green:0.47, blue:0.62, alpha:1.0),
                     "table" : UIColor(red:0.09, green:0.09, blue:0.10, alpha:1.0),
                     "cell" : UIColor(red:0.12, green:0.12, blue:0.13, alpha:1.0),
                     "com" : UIColor(red:0.73, green:0.73, blue:0.74, alpha:1.0),
                     "name" : UIColor(red:0.73, green:0.73, blue:0.74, alpha:1.0),
                     "details" : UIColor.gray.withAlphaComponent(0.7),
                     "sub" : UIColor(red:0.64, green:0.50, blue:0.68, alpha:1.0),
                     "seperator" : UIColor(red:0.21, green:0.24, blue:0.29, alpha:0.9),
                     "url" : UIColor(red:0.31, green:0.60, blue:0.91, alpha:1.0),
                     "replyCountButton" : UIColor(red:0.31, green:0.47, blue:0.62, alpha:0.9)]

let themeDict = darkThemeDict

class SideBarTableCell: UITableViewCell {
    
    let threadImage: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "placeholder-tn")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 2.0
        return imgView
    }()
    
    let boardLabel: UILabel = {
        let label = UILabel()
        label.text = "/ /"
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = false
        label.font = label.font.withSize(14)
        label.textColor = themeDict["sub"]
        return label
    }()
    
    let threadLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = false
        label.font = label.font.withSize(12)
        label.textColor = themeDict["com"]
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(threadImage)
        contentView.addSubview(boardLabel)
        contentView.addSubview(threadLabel)
        print(contentView.frame.width, contentView.center.x)
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("has not been implemented")
    }
    
    func setupConstraints() {
        threadImage.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.left.equalTo(contentView).offset(10)
            make.top.equalTo(contentView).offset(15)
            make.bottom.equalTo(contentView).offset(-15)
        }
        
        boardLabel.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.leading.equalTo(threadImage.snp.trailing).offset(10)
            make.top.equalTo(contentView).offset(25)
        }
        
        threadLabel.snp.makeConstraints { make in
            make.top.equalTo(boardLabel.snp.bottom).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.leading.equalTo(threadImage.snp.trailing).offset(10)
        }
    }
}

