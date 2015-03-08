//
//  KHASwitchCell.swift
//  KHAForm
//
//  Created by Kohei Hayakawa on 3/8/15.
//  Copyright (c) 2015 Kohei Hayakawa. All rights reserved.
//

import UIKit

class KHASwitchCell: UITableViewCell {

    let sswitch: UISwitch = UISwitch()
    
    class var cellID: String {
        return "KHASwitchCell"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.selectionStyle = .None
        super.textLabel?.text = "Label"
        super.accessoryView = sswitch
    }
}
