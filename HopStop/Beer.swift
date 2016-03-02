//
//  Beer.swift
//  HopStop
//
//  Created by Ethan Haley on 2/29/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import Foundation
import CoreData

class Beer: NSManagedObject {
    
    struct Keys {
        
        static let Descrip = "descrip"
        static let BrewDBID = "dbID"
        static let Name = "beerName"
        static let Brewer = "brewer"
        static let BrewerID = "breweryId"
        static let Rating = "rating"
    }
    
    
    @NSManaged var descrip: String
    @NSManaged var dbID: String
    @NSManaged var beerName: String
    @NSManaged var brewer: String
    @NSManaged var breweryId: String
    @NSManaged var rating: Int
   
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Beer", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
    }
    init(dict: [String: AnyObject], context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Beer", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        dbID = dict[Keys.BrewDBID] as! String
        descrip = dict[Keys.Descrip] as! String
        beerName = dict[Keys.Name] as! String
        brewer = dict[Keys.Brewer] as! String
        breweryId = dict[Keys.BrewerID] as! String
        rating = dict[Keys.Rating] as? Int ?? -1
                
    }
    
}
