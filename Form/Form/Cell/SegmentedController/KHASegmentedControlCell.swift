//
//  KHASegmentedControlCell.swift
//  KHAForm
//
//  Created by Kohei Hayakawa on 3/8/15.
//  Copyright (c) 2015 Kohei Hayakawa. All rights reserved.
//

import UIKit

class KHASegmentedControlCell: UITableViewCell {
    
    let segmentedControl: UISegmentedControl = UISegmentedControl()
    
    class var cellID: String {
        return "KHASegmentedControlCell"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.selectionStyle = .None
        super.textLabel?.text = "Label"
        segmentedControl = UISegmentedControl(items: ["First", "Second"])
        super.accessoryView = segmentedControl
    }
}