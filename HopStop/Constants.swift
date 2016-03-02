//
//  Constants.swift
//  HopStop
//
//  Created by Ethan Haley on 2/29/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import Foundation

extension BreweryDbClient {
    
    struct Constants {
        static let ApiKey = "d6adf3edd3cac4fca45467b41488f57f"
        static let BaseUrl = "http://api.brewerydb.com/v2/"
    }
    struct Keys {
        static let ID = "id"
        static let Query = "q"
        static let BreweryToo = "withBreweries"
        static let Page = "p"
        static let Category = "type"
        static let ABV = "abv"
    }
    struct Resources {
        static let BeerSearch = "beers/"
        static let BrewerySearch = "brewery/"
        static let Search = "search"
        static let BreweryByID = "brewery/:breweryId"
    }
    
    struct Params {
        static let Name = "name"
        static let ABV = "abv"
        static let ID = "id"
        static let Descrip = "description"
    }
}
