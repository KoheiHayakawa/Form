//
//  ExampleFormTableViewController.swift
//  ExampleForm
//
//  Created by Kohei Hayakawa on 2/28/15.
//  Copyright (c) 2015 Kohei Hayakawa. All rights reserved.
//

import UIKit

class ExampleForm: KHAForm {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func formCellsInForm(form: KHAForm) -> [[KHAFormCell]] {
        
        // setup cells in form
        let cell1 = initFormCellWithType(.TextField)        as KHATextFieldFormCell
        let cell2 = initFormCellWithType(.SegmentedControl) as KHASegmentedControlFormCell
        let cell3 = initFormCellWithType(.Switch)           as KHASwitchFormCell
        let cell4 = initFormCellWithType(.Date)             as KHADateFormCell
        let cell5 = initFormCellWithType(.Date)             as KHADateFormCell
        let cell6 = initFormCellWithType(.TextView)         as KHATextViewFormCell
        let cell7 = initFormCellWithType(.Button)           as KHAButtonFormCell
        let cell8 = initFormCellWithType(.Button)           as KHAButtonFormCell
        
        cell1.textField.text = "foo"
        cell1.textField.placeholder = "placeholder"
        cell1.textField.clearButtonMode = UITextFieldViewMode.Always
        
        cell2.segmentedControl.setTitle("First", forSegmentAtIndex: 0)
        cell2.segmentedControl.setTitle("Second", forSegmentAtIndex: 1)
        cell2.segmentedControl.insertSegmentWithTitle("Third", atIndex: 2, animated: false) // Add segment
        
        cell4.date = NSDate()
        
        cell5.date = NSDate()
        
        cell6.textView.placeholder = "placeholder"
        
        cell7.button.setTitle("Delete", forState: .Normal)
        cell7.button.setTitleColor(UIColor.redColor(), forState: .Normal)
        cell7.button.addTarget(self, action: Selector("didPressedDeleteButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell8.button.setTitle("Cancel", forState: .Normal)
        cell8.button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        cell8.button.addTarget(self, action: Selector("didPressedCancelButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        return [[cell1, cell2, cell3], [cell4, cell5], [cell6], [cell7, cell8]]
    }

    func didPressedDeleteButton(sender: UIButton) {
        println("delete")
        
        // We can access to the first cell contains text field...
        let cell1 = formCellForIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as KHATextFieldFormCell
        println(cell1.textField.text)
        
        // ...and second cell contains segmented controller, etc...
        let cell2 = formCellForIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as KHASegmentedControlFormCell
        println(cell2.segmentedControl.selectedSegmentIndex)
        
        let cell3 = formCellForIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as KHASwitchFormCell
        println(cell3.sswitch.on)
        
        let cell4 = formCellForIndexPath(NSIndexPath(forItem: 0, inSection: 1)) as KHADateFormCell
        println(cell4.date)
    }
    
    func didPressedCancelButton(sender: UIButton) {
        println("cancel")
    }

}
