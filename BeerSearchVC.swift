//
//  BeerSearchVC.swift
//  HopStop
//
//  Created by Ethan Haley on 2/29/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit
import CoreData

class BeerSearchVC: BeerVC, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searcher: UISearchBar!
    
    @IBOutlet weak var searchTable: UITableView!
    
    @IBOutlet weak var currentBeerName: UILabel!
    @IBOutlet weak var currentBeerBrewer: UILabel!
    
    @IBOutlet weak var watchTable: UITableView!
    
    @IBAction func addToWatchlist(sender: UIButton) {
        
        if currentHalfBeer == nil {
            displayGenericAlert("Use the search bar to find a beer to add to your watchlist.", message: "")
        } else {
            
            var beerDict = [String: AnyObject]()
            
            beerDict[Beer.Keys.BrewDBID] = currentHalfBeer?.id ?? ""
            beerDict[Beer.Keys.Brewer] = currentHalfBeer?.maker ?? ""
            beerDict[Beer.Keys.Descrip] = currentHalfBeer?.notes ?? ""
            beerDict[Beer.Keys.Name] = currentHalfBeer?.name ?? ""
            beerDict[Beer.Keys.BrewerID] = currentHalfBeer?.brewerId
            beerDict[Beer.Keys.Rating] = nil
            
            let _ = Beer(dict: beerDict, context: sharedContext)
           
        }
        CoreDataStackManager.sharedInstance().saveContext()
        
        currentBeerName.text = ""
        currentBeerBrewer.text = ""
        currentHalfBeer = nil
        halfBeerResults = [HalfBeer]()
    }
    
    var currentHalfBeer: HalfBeer?  // since searchBar is returning results in this form
    
    var halfBeerResults = [HalfBeer]()  // this, rather than a temporary managed object context, is the scratchpad here
    
    var searchTask: NSURLSessionDataTask?
    
    let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    
    // MARK: - FetchedResults Controller
    
    lazy var watchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Beer")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "beerName", ascending: true)]
        
        let watchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        watchedResultsController.delegate = self
        
        return watchedResultsController
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showBackgroundBeer()
        
       // tapRecognizer!.cancelsTouchesInView = false  // otherwise tableView taps don't work
    }
    
    override func viewWillAppear(animated: Bool) {
        do {
            try watchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    // MARK: - UITableView delegate methods:
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTable {
            return halfBeerResults.count
        } else {   // table is watchlist
            return watchedResultsController.sections?[section].numberOfObjects ?? 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == searchTable {
            
            let beerCell = tableView.dequeueReusableCellWithIdentifier("beerCell")!
            
            let halfBeer = halfBeerResults[indexPath.row]
            
            beerCell.textLabel!.text = halfBeer.name
            beerCell.detailTextLabel!.text = halfBeer.maker
            
            return beerCell
            
        } else {  //watchlist
            
            let watchCell = tableView.dequeueReusableCellWithIdentifier("watchTableCell")!
            
            let beer = watchedResultsController.objectAtIndexPath(indexPath) as! Beer
            
            watchCell.textLabel!.text = beer.beerName ?? ""
            watchCell.detailTextLabel!.text = beer.brewer ?? ""
            
            return watchCell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == searchTable {
            
            currentHalfBeer = halfBeerResults[indexPath.row]
            
            currentBeerName.text = currentHalfBeer!.name
            currentBeerBrewer.text = currentHalfBeer!.maker
            
            tableView.hidden = true
            
        } else {  // watchlist
            
            let watchbeer = watchedResultsController.objectAtIndexPath(indexPath) as! Beer
            let detesVC = storyboard?.instantiateViewControllerWithIdentifier("beerDetail") as! BeerDetailVC
            detesVC.beer = watchbeer
            navigationController?.pushViewController(detesVC, animated: true)
        }
        
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete && tableView == watchTable {
            let beer = watchedResultsController.objectAtIndexPath(indexPath) as! Beer
            sharedContext.deleteObject(beer)
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
        
    // MARK: - Search Bar Delegate methods:
    
    // -- TableView to be visible only while searchBar is active
    // -- Changing searchBar text cancels old task and starts new
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchTable.hidden = false
        
        // Cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        // If the text is empty don't search
        if searchText == "" {
            searchTable.hidden = true
            halfBeerResults = [HalfBeer]()
            searchTable.reloadData()
            objc_sync_exit(self) // I see this in Jason's code but not Jarrod's, and not sure why
            return
        }
        
        // Start a new search task
        searchTask = BreweryDbClient.sharedInstance.halfBeerSearch(searchText) { halfbeerlist, error in
            self.searchTask = nil
            if let result = halfbeerlist {
                self.halfBeerResults = result
                dispatch_async(dispatch_get_main_queue()) {
                    self.searchTable.reloadData()
                }
            } else {
                if let _ = error {
                    self.displayErrorAlert(error!)
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    // MARK: - Fetched Results Controller Delegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
        watchTable.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType) {
            
            switch type {
            case .Insert:
                watchTable.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            case .Delete:
                watchTable.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            default:
                return
            }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
            
            switch type {
            case .Insert:
                watchTable.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
                
            case .Delete:
                watchTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                
            case .Update:
                break
                
            case .Move:
                watchTable.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                watchTable.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        watchTable.endUpdates()
    }
    
    
}