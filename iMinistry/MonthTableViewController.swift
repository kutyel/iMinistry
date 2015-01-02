//
//  MonthTableViewController.swift
//  iMinistry
//
//  Created by Flavio Corpa on 28/12/14.
//  Copyright (c) 2014 Flavio Corpa. All rights reserved.
//

import UIKit
import CoreData

class MonthTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext?
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var booksLabel: UILabel!
    @IBOutlet var magazinesLabel: UILabel!
    
    // Query to Core Data
    
    var fetchedResultsController: NSFetchedResultsController {
        
        if self._fetchedResultsController != nil {
            return self._fetchedResultsController!
        }
        
        let managedObjectContext = self.managedObjectContext!
        
        // Query all the reports ascending by the number of hours
        
        let entity = NSEntityDescription.entityForName("Report", inManagedObjectContext: managedObjectContext)
        let sort = NSSortDescriptor(key: "hours", ascending: true)
        let req = NSFetchRequest()
        req.entity = entity
        req.sortDescriptors = [sort]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: req, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        self._fetchedResultsController = aFetchedResultsController
        
        var e: NSError?
        if !self._fetchedResultsController!.performFetch(&e) {
            println("Error fetching: \(e?.localizedDescription)")
            abort()
        }
        
        return self._fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController?
    
    // Initial load
    
    override func viewDidLoad() {
        
        self.hoursLabel.textAlignment = .Right
        self.booksLabel.textAlignment = .Right
        self.magazinesLabel.textAlignment = .Right
        
        let month = NSCalendar.currentCalendar().components(.MonthCalendarUnit, fromDate: NSDate()).month
        
        self.title = months[month - 1]
    }
    
    // Report logic inside event
    
    override func viewWillAppear(animated: Bool) {
        
        var hours = 0.0
        var books = 0
        var magazines = 0
        
        let reports = self.fetchedResultsController.fetchedObjects as [Report]
        
        for report in reports {
            
            if report.hours != nil {
                hours += report.hours as Double
            }
            if report.books != nil {
                books += report.books as Int
            }
            if report.magazines != nil {
                magazines += report.magazines as Int
            }
        }
        
        self.hoursLabel.text = String(format: "%.2f", hours)
        self.booksLabel.text = String(books)
        self.magazinesLabel.text = String(magazines)
    }

    // TableView update events
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    // Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let managedObjectContext = self.fetchedResultsController.managedObjectContext
        let report = NSEntityDescription.insertNewObjectForEntityForName("Report", inManagedObjectContext: managedObjectContext) as Report
        
        let nav = segue.destinationViewController as UINavigationController
        let add = nav.topViewController as AddReportTableViewController
        
        add.report = report
        add.didCancel = {
            cont in self.dismissViewControllerAnimated(true, completion: nil)
        }
        add.didFinish = {
            cont in self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
