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

    var hours: NSDecimalNumber = 0
    var books = 0
    var magazines = 0
    
    var managedObjectContext: NSManagedObjectContext?
    
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
        let month = NSCalendar.currentCalendar().components(.MonthCalendarUnit, fromDate: NSDate()).month
        self.title = monthToString(month)
    }
    
    func monthToString(month: Int) -> String {
        var monthName = ""
        switch month {
        case 1:
            monthName = "January"
        case 2:
            monthName = "February"
        case 3:
            monthName = "March"
        case 4:
            monthName = "April"
        case 5:
            monthName = "May"
        case 6:
            monthName = "June"
        case 7:
            monthName = "July"
        case 8:
            monthName = "August"
        case 9:
            monthName = "September"
        case 10:
            monthName = "October"
        case 11:
            monthName = "November"
        case 12:
            monthName = "December"
        default:
            monthName = ""
        }
        return monthName
    }
    
    // Report logic inside event
    
    override func viewWillAppear(animated: Bool) {
        
        let reports = self.fetchedResultsController.fetchedObjects as [Report]
        
        for report in reports {
            if report.hours != nil {
                if report.hours != NSDecimalNumber.notANumber() {
                    hours.decimalNumberByAdding(report.hours!)
                }
            }
            if report.books != nil {
                books += report.books as Int
            }
            if report.magazines != nil {
                magazines += report.magazines as Int
            }
        }
        
        self.hoursLabel.text = "\(hours)"
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
