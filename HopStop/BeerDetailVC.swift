//
//  BeerDetailVC.swift
//  HopStop
//
//  Created by Ethan Haley on 2/29/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

class BeerDetailVC: BeerVC {
    
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var brewerLabel: UILabel!
    @IBOutlet weak var detes: UITextView!
    
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    
    var beer: Beer!
    
    var newRating: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // populate UI fields with ManagedObject's properties
        beerNameLabel.text = beer.beerName
        brewerLabel.text = beer.brewer
        detes.text = beer.descrip
        ratingLabel.text = beer.rating == -1 ? "none " : String(beer.rating)
        
        let rated: Int = beer.rating == -1 ? 50 : beer.rating
        ratingSlider.setValue(Float(rated), animated: true)
        
        if beer.descrip == "" {
            detes.text = "Unfortunately, \(beer.brewer) has not yet provided any notes or description.  You can always tap in this text area to add your own notes about this beer."
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()  // to adjust view origin when keyboard appears
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Save and persist any user changes to beer's notes and rating
        beer.descrip = detes.text
        
        if newRating != nil {
            beer.rating = newRating!
        }
        
        CoreDataStackManager.sharedInstance().saveContext()

        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func brewerStory(sender: UIButton) {
        
        let brewerDetail = storyboard?.instantiateViewControllerWithIdentifier("brewerDetailVC") as! BreweryDetailVC
        brewerDetail.beer = beer
        
        navigationController?.pushViewController(brewerDetail, animated: true)
    }
    
    @IBAction func rate(sender: UISlider) {
        // User set the beer rating
        newRating = lroundf(ratingSlider.value)
        
        ratingLabel.text = String(newRating!)
    }
    
}
