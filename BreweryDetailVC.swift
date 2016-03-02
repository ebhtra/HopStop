//
//  BreweryDetailVC.swift
//  HopStop
//
//  Created by Ethan Haley on 3/1/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

class BreweryDetailVC: UIViewController {
    
    @IBOutlet weak var brewerLabel: UILabel!
    
    @IBOutlet weak var breweryNotes: UITextView!
    
    // Passed over from previous screen
    var beer: Beer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showBackgroundBeer()
        
        breweryNotes.editable = false
        
        brewerLabel.text = beer.brewer
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        view.addSubview(activityIndicator)
        activityIndicator.color = AppDelegate.tan
        activityIndicator.frame = view.bounds
        
        if !Reachability.isConnectedToNetwork() {
            breweryNotes.text = "THERE SEEMS TO BE NO CONNECTION TO THE INTERNET RIGHT NOW."
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                activityIndicator.startAnimating()
            }
            BreweryDbClient.sharedInstance.brewerySearch(beer.breweryId) { details, error in
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if let result = details {
                        self.breweryNotes.text = result as! String
                        if self.breweryNotes.text.isEmpty {
                            self.breweryNotes.text = "Sorry, no story for this brewery"
                        }
                    } else {
                        if let err = error {
                            self.displayErrorAlert(err)
                        }
                    }
                    activityIndicator.removeFromSuperview()
                }
            }
        }
    }
}
