//
//  ViewControllerExtensions.swift
//  HopStop
//
//  Created by Ethan Haley on 2/29/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit
import MapKit

extension UIViewController {
    
    func displayErrorAlert(error: NSError) {
        if let errorMessage = error.userInfo["error"] as? String {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func displayGenericAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showBackgroundBeer() {  
        self.view.backgroundColor = UIColor.whiteColor()
        let colorTop = UIColor(red: 0.9, green: 0.6, blue: 0.1, alpha: 0.0).CGColor
        let colorMid = UIColor(red: 1.0, green: 0.7, blue: 0.1, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 0.85, green: 0.4, blue: 0.05, alpha: 1.0).CGColor
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorMid, colorBottom]
        backgroundGradient.locations = [0.2, 0.25, 1.0]
        backgroundGradient.frame = CGRect(x: 0, y: 0, width: view.frame.height, height: view.frame.height)
        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
    }
    
    func subscribeToKeyboardNotifications() {
        // register the VC to respond to keyboard visibility change notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        // de-register the VC to respond to keyboard visibility change notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // if top of field being edited is less than 100 higher from the bottom than the top of keyboard will be,
        //    raise the view to get it there during editing. That gives user at least 100 points of clearance to type
        let hKeys = getKeyboardHeight(notification)
        var yUp = CGFloat(0)
        for v in view.subviews {  // find which field is editing
            if v.isFirstResponder() {
                yUp = view.frame.height - v.frame.minY
            }
        }
        view.frame.origin.y -= max(0, hKeys + 100 - yUp)
        
    }
    
    func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        // get the userInfo dictionary from the notification
        let userInfo = notification.userInfo
        
        // get the keyboard CGRect from the userInfo dictionary
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.CGRectValue().height
    }
    
}

