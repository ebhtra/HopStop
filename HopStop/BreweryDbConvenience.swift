//
//  BreweryDbConvenience.swift
//  HopStop
//
//  Created by Ethan Haley on 2/29/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import Foundation

extension BreweryDbClient {
    
    func halfBeerSearch(searchString: String, completionHandler: (result: [HalfBeer]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        let parameters = [Keys.Query: searchString, Keys.BreweryToo: "Y", Keys.Category: "beer"]
        let resource = Resources.Search
        
        let task = taskForResource(resource, parameters: parameters) { JSONResult, error in
            
            if let error = error {
                completionHandler(result: nil, error: error)
                
            } else {
                
                if let beerdata = JSONResult.valueForKey("data") as? [[String : AnyObject]] {
                    
                    var beerlist = [HalfBeer]()
                    
                    for beer in beerdata {
                        
                        let name = beer["name"] as! String
                        var maker = ""
                        let id = beer["id"] as! String
                        let notes = beer["description"] as? String ?? ""
                        var breweryId = ""
                        
                        // TODO -- add multiple brewers to one beer, with a to-many relationship in datamodel
                        
                        if let brewers = beer["breweries"] as? [[String : AnyObject]] {
                            
                            maker = (brewers[0]["name"] ?? brewers[0]["nameShortDisplay"]) as! String
                            breweryId = (brewers[0]["id"]) as! String
                            // (brewers[0]["images"]!["icon"] as? String) holds brewery icons if needed later
                            
                        }
                        beerlist.append(HalfBeer(name: name, maker: maker, id: id, notes: notes, brewerId: breweryId))
                    }
                    completionHandler(result: beerlist, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "halfBeerSearch parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse halfBeerSearch"]))
                }
            }
        }
        
        return task
    }
    
    func brewerySearch(breweryId: String, completion: CompletionHandler) -> NSURLSessionDataTask? {
        
        let params = [Beer.Keys.BrewerID: breweryId]
        let resource = Resources.BreweryByID
        
        let task = taskForResource(resource, parameters: params) { JSONResult, error in
            
            if let error = error {
                completion(result: nil, error: error)
                
            } else {
               
                if let breweryData = JSONResult.valueForKey("data") as? [String : AnyObject] {
                    
                    if let notes = breweryData["description"] as? String {
                        completion(result: notes, error: nil)
                    } else {
                        completion(result: "Sorry--no description is provided by the brewery.", error: nil)
                    }
                } else {
                    print("can't find data key in JSON results")
                    completion(result: "", error: nil)
                }
            }
        }
        return task
    }
        
    
}