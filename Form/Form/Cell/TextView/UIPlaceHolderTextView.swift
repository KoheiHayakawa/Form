//
//  UIPlaceHolderTextView.swift
//  HotPepperFashion-Shop
//
//  Created by Kohei Hayakawa on 2/13/15.
//  Copyright (c) 2015 The H-Team. All rights reserved.
//
//  これ使いました
//  http://qiita.com/matsuhisa@github/items/5f4877e8ec89729de824

//import UIKit
//
//public class UIPlaceholderTextView: UITextView {
//    
//    lazy var placeholderLabel:UILabel = UILabel()
//    var placeholderColor:UIColor      = UIColor.lightGrayColor()
//    var placeholder:NSString          = ""
//
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
//    
//    func setText(text:NSString) {
//        super.text = text
//        self.textChanged(nil)
//    }
//    
//    override public func drawRect(rect: CGRect) {
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChanged:", name: UITextViewTextDidChangeNotification, object: nil)
//        
//        if(self.placeholder.length > 0) {
//            self.placeholderLabel.frame           = CGRectMake(4,8,self.bounds.size.width - 16,0)
//            self.placeholderLabel.lineBreakMode   = NSLineBreakMode.ByWordWrapping
//            self.placeholderLabel.numberOfLines   = 0
//            self.placeholderLabel.font            = self.font
//            self.placeholderLabel.backgroundColor = UIColor.clearColor()
//            self.placeholderLabel.textColor       = self.placeholderColor
//            self.placeholderLabel.alpha           = 0
//            self.placeholderLabel.tag             = 999
//            
//            self.placeholderLabel.text = self.placeholder
//            self.placeholderLabel.sizeToFit()
//            self.addSubview(placeholderLabel)
//        }
//        
//        self.sendSubviewToBack(placeholderLabel)
//        
//        if(self.text.utf16Count == 0 && self.placeholder.length > 0){
//            self.viewWithTag(999)?.alpha = 1
//        }
//        
//        super.drawRect(rect)
//    }
//    
//    public func textChanged(notification:NSNotification?) -> (Void) {
//        if(self.placeholder.length == 0){
//            return
//        }
//        
//        if(countElements(self.text) == 0) {
//            self.viewWithTag(999)?.alpha = 1
//        }else{
//            self.viewWithTag(999)?.alpha = 0
//        }
//    }
//    
//}