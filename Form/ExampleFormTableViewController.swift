//
//  ExampleFormTableViewController.swift
//  ExampleForm
//
//  Created by Kohei Hayakawa on 2/28/15.
//  Copyright (c) 2015 Kohei Hayakawa. All rights reserved.
//

import UIKit

class ExampleFormTableViewController: FormTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup cells in form
        let cell1 = cellForRowType(.TextField)        as KHATextFieldCell
        let cell2 = cellForRowType(.SegmentedControl) as KHASegmentedControlCell
        let cell3 = cellForRowType(.Switch)           as KHASwitchCell
        let cell4 = cellForRowType(.Date)             as KHADateCell
        let cell5 = cellForRowType(.Date)             as KHADateCell
        let cell6 = cellForRowType(.TextView)         as KHATextViewCell
        let cell7 = cellForRowType(.Button)           as KHAButtonCell
        let cell8 = cellForRowType(.Button)           as KHAButtonCell

        cell1.textField.text = "foo"
        cell1.textField.placeholder = "placeholder"
        cell1.textField.clearButtonMode = UITextFieldViewMode.Always
        
        cell2.segmentedControl.setTitle("foo", forSegmentAtIndex: 0)
        cell2.segmentedControl.setTitle("bar", forSegmentAtIndex: 1)
        cell2.segmentedControl.insertSegmentWithTitle("baz", atIndex: 2, animated: false) // Add segment
        
        cell4.detailTextLabel?.text = NSDate().description
        
        cell5.detailTextLabel?.text = NSDate().description

        cell6.textView.placeholder = "placeholder"
        
        cell7.button.setTitle("Delete", forState: .Normal)
        cell7.button.setTitleColor(UIColor.redColor(), forState: .Normal)
        cell7.button.addTarget(self, action: Selector("pushedDeleteButton:"), forControlEvents: UIControlEvents.TouchUpInside)

        cell8.button.setTitle("Cancel", forState: .Normal)
        cell8.button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        cell8.button.addTarget(self, action: Selector("pushedCancelButton:"), forControlEvents: UIControlEvents.TouchUpInside)

        initFormWithCells([[cell1, cell2, cell3], [cell4, cell5], [cell6], [cell7, cell8]])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pushedDeleteButton(sender: UIButton) {
        println("delete")
        
        // We can access to the first cell contains text field...
        let cell1 = cellForIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as KHATextFieldCell
        println(cell1.textField.text)
        
        // ...and second cell contains segmented controller, etc...
        let cell2 = cellForIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as KHASegmentedControlCell
        println(cell2.segmentedControl.selectedSegmentIndex)
        
        let cell3 = cellForIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as KHASwitchCell
        println(cell3.sswitch.on)
    }
    
    func pushedCancelButton(sender: UIButton) {
        println("cancel")
    }

}
