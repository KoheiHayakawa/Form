//
//  FormTableViewController.swift
//  Form
//
//  Created by Kohei Hayakawa on 2/20/15.
//  Copyright (c) 2015 Kohei Hayakawa. All rights reserved.
//

import UIKit

class FormTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    enum RowType: String {
        case TextField        = "TextField"
        case SegmentedControl = "SegmentedControl"
        case Switch           = "Switch"
        case DateStart        = "DateStart"
        case DateEnd          = "DateEnd"
        case TextView         = "TextView"
        case Button           = "Button"
        case DatePicker       = "DatePicker"
        
        func cellId() -> String {
            switch self {
            case .TextField:        return "KHATextFieldCell"
            case .SegmentedControl: return "KHASegmentedControlCell"
            case .Switch:           return "KHASwitchCell"
            case .DateStart:        return "dateCell"
            case .DateEnd:          return "dateCell"
            case .TextView:         return "textViewCell"
            case .Button:           return "buttonCell"
            case .DatePicker:       return "datePickerCell"
            }
        }
    }
    
    private var cells:[[UITableViewCell]] = []
    private var datePickerIndexPath: NSIndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register custom table view cell
        let buttonCell = UINib(nibName: "ButtonTableViewCell", bundle: nil)
        let textViewCell = UINib(nibName: "TextViewTableViewCell", bundle: nil)
        let dateCell = UINib(nibName: "DateTableViewCell", bundle: nil)
        let datePickerCell = UINib(nibName: "DatePickerTableViewCell", bundle: nil)
        
        tableView.registerNib(buttonCell, forCellReuseIdentifier: "buttonCell")
        tableView.registerNib(textViewCell, forCellReuseIdentifier: "textViewCell")
        tableView.registerNib(dateCell, forCellReuseIdentifier: "dateCell")
        tableView.registerNib(datePickerCell, forCellReuseIdentifier: "datePickerCell")
        
        tableView.registerClass(KHATextFieldCell.self, forCellReuseIdentifier: KHATextFieldCell.cellID)
        tableView.registerClass(KHASegmentedControlCell.self, forCellReuseIdentifier: KHASegmentedControlCell.cellID)
        tableView.registerClass(KHASwitchCell.self, forCellReuseIdentifier: KHASwitchCell.cellID)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initFormWithCells(cells: [[UITableViewCell]]) {
        self.cells = cells
    }
    
    func cellForRowType(rowType: RowType) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(rowType.cellId()) as UITableViewCell
        return cell
    }
    
    func cellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row]
    }
    
    
    // MARK: Utility
    
    private func trimmedDateStringFromDateString(string:String) -> String {
        let df1 = NSDateFormatter()
        df1.dateFormat = "yyyy-MM-dd HH:mm:SS z"
        if let date = df1.dateFromString(string) {
            let df2 = NSDateFormatter()
            df2.dateStyle = .ShortStyle
            df2.timeStyle = .ShortStyle
            return df2.stringFromDate(date)
        } else {
            return string
        }
    }
    
    private func dateFromTrimmedDateString(string:String) -> NSDate {
        let df = NSDateFormatter()
        df.dateStyle = .ShortStyle
        df.timeStyle = .ShortStyle
        return df.dateFromString(string)!
    }
    

    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var before = false
        if hasInlineDatePicker() {
            before = (datePickerIndexPath?.row < indexPath.row) && (datePickerIndexPath?.section == indexPath.section)
        }
        let row = (before ? indexPath.row - 1 : indexPath.row)

        var cell = tableView.dequeueReusableCellWithIdentifier(RowType.DatePicker.cellId()) as UITableViewCell
        if !hasPickerAtIndexPath(indexPath) {
            cell = cells[indexPath.section][row]
        }
        return cell.bounds.height
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cells.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if hasInlineDatePicker() && hasDateCellAtSection(section) {
            // we have a date picker, so allow for it in the number of rows in this section
            return cells[section].count + 1
        }
        return cells[section].count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        var cell = tableView.dequeueReusableCellWithIdentifier(RowType.DatePicker.cellId()) as UITableViewCell
        
        if !hasPickerAtIndexPath(indexPath) {
            cell = cells[indexPath.section][indexPath.row]
        }
        
        switch cell.reuseIdentifier! {
        case RowType.TextField.cellId():
            (cell as KHATextFieldCell).textField.delegate = self
        case RowType.TextView.cellId():
            (cell as TextViewTableViewCell).textView.delegate = self
            cell.selectionStyle = .None;
        case RowType.DateStart.cellId():
            let dateStr = (cell as DateTableViewCell).detailTextLabel?.text
            (cell as DateTableViewCell).detailTextLabel?.text = trimmedDateStringFromDateString(dateStr!)
        case RowType.DatePicker.cellId():
            (cell as DatePickerTableViewCell).datePicker.addTarget(self, action: Selector("didDatePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        default:
            break // do nothing
        }
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell?.reuseIdentifier == RowType.DateStart.cellId() || cell?.reuseIdentifier == RowType.DateEnd.cellId() {
            displayInlineDatePickerForRowAtIndexPath(indexPath)
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        view.endEditing(true)
    }
    
    
    // MARK: - DatePicker
    
    /*! Updates the UIDatePicker's value to match with the date of the cell above it.
    */
    private func updateDatePicker() {
        if let indexPath = datePickerIndexPath {
            if let associatedDatePickerCell = tableView.cellForRowAtIndexPath(indexPath) {
                let cell = cells[indexPath.section][indexPath.row - 1] as DateTableViewCell
                if let dateStr = cell.detailTextLabel?.text {
                    (associatedDatePickerCell as DatePickerTableViewCell).datePicker.setDate(dateFromTrimmedDateString(dateStr), animated: false)
                }
            }
        }
    }
    
    private func hasDateCellAtSection(section: Int) -> Bool {
        let cellsAtSection = cells[section]
        for cell in cellsAtSection {
            let rowType = cell.reuseIdentifier
            if (rowType == RowType.DateStart.cellId()) || (rowType == RowType.DateEnd.cellId()) {
                return true
            }
        }
        return false
    }
    
    /*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
        @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
    */
    private func hasPickerAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return hasInlineDatePicker() && (datePickerIndexPath?.row == indexPath.row) && (datePickerIndexPath?.section == indexPath.section)
    }
    
    /*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
    */
    private func hasInlineDatePicker() -> Bool {
        return datePickerIndexPath? != nil
    }
    
    /*! Adds or removes a UIDatePicker cell below the given indexPath.
        @param indexPath The indexPath to reveal the UIDatePicker.
    */
    private func toggleDatePickerForSelectedIndexPath(indexPath: NSIndexPath) {
        tableView.beginUpdates()
        let indexPaths = [NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        tableView.endUpdates()
    }
    
    /*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
        @param indexPath The indexPath to reveal the UIDatePicker.
    */
    private func displayInlineDatePickerForRowAtIndexPath(indexPath: NSIndexPath) {
        
        // display the date picker inline with the table content
        tableView.beginUpdates()
        
        var before = false // indicates if the date picker is below "indexPath", help us determine which row to reveal
        if hasInlineDatePicker() {
            before = (datePickerIndexPath?.row < indexPath.row) && (datePickerIndexPath?.section == indexPath.section)
        }
        
        var sameCellClicked = ((datePickerIndexPath?.row == indexPath.row + 1) && (datePickerIndexPath?.section == indexPath.section))
        
        // remove any date picker cell if it exists
        if hasInlineDatePicker() {
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: datePickerIndexPath!.row, inSection: datePickerIndexPath!.section)], withRowAnimation: .Fade)
            datePickerIndexPath = nil
        }
        
        if !sameCellClicked {
            // hide the old date picker and display the new one
            let rowToReveal = (before ? indexPath.row - 1 : indexPath.row)
            let indexPathToReveal = NSIndexPath(forRow: rowToReveal, inSection: indexPath.section)
            toggleDatePickerForSelectedIndexPath(indexPathToReveal)
            datePickerIndexPath = NSIndexPath(forRow: indexPathToReveal.row + 1, inSection: indexPath.section)
        }
        
        // always deselect the row containing the start or end date
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        tableView.endUpdates()
        
        // inform our date picker of the current date to match the current cell
        updateDatePicker()
    }
    
    private func removeAnyDatePickerCell() {
        if hasInlineDatePicker() {
            tableView.beginUpdates()
            
            let indexPath = NSIndexPath(forRow: datePickerIndexPath!.row, inSection: datePickerIndexPath!.section)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            datePickerIndexPath = nil
            
            // always deselect the row containing the start or end date
            tableView.deselectRowAtIndexPath(indexPath, animated:true)
            
            tableView.endUpdates()
            
            // inform our date picker of the current date to match the current cell
            updateDatePicker()
        }
    }
    
    // MARK: - Action

    /*! User chose to change the date by changing the values inside the UIDatePicker.
    
    @param sender The sender for this action: UIDatePicker.
    */
    func didDatePickerValueChanged(sender: UIDatePicker) {
        
        var targetedCellIndexPath: NSIndexPath?
        
        if self.hasInlineDatePicker() {
            // inline date picker: update the cell's date "above" the date picker cell
            targetedCellIndexPath = NSIndexPath(forRow: datePickerIndexPath!.row - 1, inSection: datePickerIndexPath!.section)
        } else {
            // external date picker: update the current "selected" cell's date
            targetedCellIndexPath = tableView.indexPathForSelectedRow()!
        }
        
        // update the cell's date string
        var cell = tableView.cellForRowAtIndexPath(targetedCellIndexPath!) as DateTableViewCell
        let targetedDatePicker = sender
        cell.detailTextLabel?.text = trimmedDateStringFromDateString(targetedDatePicker.date.description)
    }
    
    // MARK: - Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        removeAnyDatePickerCell()
    }

    func textViewDidBeginEditing(textView: UITextView) {
        removeAnyDatePickerCell()
    }
}

