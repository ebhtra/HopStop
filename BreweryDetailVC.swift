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
    
    
    var brewer: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showBackgroundBeer()
        
        brewerLabel.text = brewer
        
        BreweryDbClient.sharedInstance.brewerySearch(brewer) { details, error in
            if let result = details {
                self.breweryNotes.text = result as! String
            } else {
                if let err = error {
                    self.displayErrorAlert(err)
                }
            }
        }
    }
}
