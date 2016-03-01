//
//  BreweryDbClient.swift
//  HopStop
//
//  Created by Ethan Haley on 2/29/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import Foundation


// This class leans heavily on Jason and Jarrod's networking code from Udacity's iOS nanodegree course
class BreweryDbClient {
    
    // singleton instance stored as static constant
    static let sharedInstance = BreweryDbClient()
    
    let session = NSURLSession.sharedSession()
    
    typealias CompletionHandler = (result: AnyObject!, error: NSError?) -> Void
    
    // MARK: - All purpose task method for data
    
    func taskForResource(resource: String, parameters: [String : AnyObject], completionHandler: CompletionHandler) -> NSURLSessionDataTask {
        //make the input mutable
        var mutableParameters = parameters
        var mutableResource = resource  // only need this if substituting a beer id for ":beerId" resource (see below)
        
        // Add in the breweryDB API Key
        mutableParameters["key"] = Constants.ApiKey
        
        // Substitute the id parameters into the resource
        if resource.rangeOfString(":beerId") != nil {
            assert(parameters[Keys.ID] != nil)
            
            mutableResource = mutableResource.stringByReplacingOccurrencesOfString(":beerId", withString: "\(parameters[Keys.ID]!)")
            mutableParameters.removeValueForKey(Keys.ID)
        }
        if resource.rangeOfString(":brewerID") != nil {
            assert(parameters[Beer.Keys.BrewerID] != nil)
            
            mutableResource = mutableResource.stringByReplacingOccurrencesOfString(":brewerID", withString: "\(parameters[Beer.Keys.BrewerID]!)")
            mutableParameters.removeValueForKey(Beer.Keys.BrewerID)

        }
        
        
        let urlString = Constants.BaseUrl + mutableResource + BreweryDbClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
         print("url for getTask in client is \(url)")
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if let error = downloadError {
                completionHandler(result: nil, error: error)
            } else {
                BreweryDbClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    // Parsing the JSON
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: CompletionHandler) {
        
        do {
            let parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            completionHandler(result: parsedResult, error: nil)
        } catch let error as NSError {
            completionHandler(result: nil, error: error)
        }
    }
    
    // URL Encoding a dictionary into a parameter string
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            // make sure that it is a string value
            let stringValue = "\(value)"
            
            // Escape it
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            // Append it
            
            if let unwrappedEscapedValue = escapedValue {
                urlVars += [key + "=" + "\(unwrappedEscapedValue)"]
            } else {
                print("Warning: trouble escaping string \"\(stringValue)\"")
            }
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
}