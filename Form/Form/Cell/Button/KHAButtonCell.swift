//
//  KHAButtonCell.swift
//  Form
//
//  Created by Kohei Hayakawa on 3/8/15.
//  Copyright (c) 2015 Kohei Hayakawa. All rights reserved.
//

import UIKit

class KHAButtonCell: UITableViewCell {
    
    let button: UIButton = UIButton()
    
    private let kFontSize: CGFloat = 15
    
    class var cellID: String {
        return "KHAButtonCell"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.selectionStyle = .None
        
        button.setTitle("Button", forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(kFontSize)
        button.titleLabel?.textAlignment = .Center
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        super.contentView.addSubview(button)

        contentView.addConstraints([
            NSLayoutConstraint(
                item: button,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .Left,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: button,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .Right,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: button,
                attribute: .Height,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1,
                constant: 44)]
        )
    }
}
