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
        
        beerNameLabel.text = beer.beerName
        brewerLabel.text = beer.brewer
        detes.text = beer.descrip
        ratingLabel.text = beer.rating == -1 ? "" : String(beer.rating)
        
        let rated: Int = beer.rating == -1 ? 50 : beer.rating
        ratingSlider.setValue(Float(rated), animated: true)
        
        
        if beer.descrip == "" {
            detes.text = "Unfortunately, \(beer.brewer) has not yet provided any notes or description."
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        beer.descrip = detes.text
        
        if newRating != nil {
            beer.rating = newRating!
        }
        
        CoreDataStackManager.sharedInstance().saveContext()

        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func brewerStory(sender: UIButton) {
        if !beer.brewer.isEmpty {
            let brewerDetail = storyboard?.instantiateViewControllerWithIdentifier("brewerDetailVC") as! BreweryDetailVC
            brewerDetail.brewer = beer.brewer
            navigationController?.pushViewController(brewerDetail, animated: true)
        }
    }
    
    @IBAction func rate(sender: UISlider) {
        
        newRating = lroundf(ratingSlider.value)
        
        ratingLabel.text = String(newRating!)
    }
    
}
