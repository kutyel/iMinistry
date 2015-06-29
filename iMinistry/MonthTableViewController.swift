//
//  MonthTableViewController.swift
//  iMinistry
//
//  Created by Flavio Corpa on 28/12/14.
//  Copyright © 2014 Flavio Corpa. All rights reserved.
//

import UIKit
import CoreData

class MonthTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var month: Int?
    var pageViewController : UIPageViewController!
    var managedObjectContext: NSManagedObjectContext?
    
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var booksLabel: UILabel!
    @IBOutlet var monthTitle: UILabel!
    @IBOutlet var magazinesLabel: UILabel!
    @IBOutlet var brochuresLabel: UILabel!
    @IBOutlet var returnVisitsLabel: UILabel!
    @IBOutlet var bibleStudiesLabel: UILabel!
    
    // Query to Core Data
    
    var fetchedResultsController: NSFetchedResultsController {
        
        if self._fetchedResultsController != nil {
            return self._fetchedResultsController!
        }
        
        // Set the initial managed object context to the app delegate one
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        // Query the reports for the current month
        
        let cal = NSCalendar.currentCalendar()
        let com = cal.components([.Year, .Month], fromDate: NSDate())
        com.day = 1
        
        if let obj: Int = month {
            com.month = obj
        }
        
        let one = NSDateComponents()
        one.month = 1
    
        let beginDate = cal.dateFromComponents(com)
        let endDate = cal.dateByAddingComponents(one, toDate: beginDate!, options: [])
        
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", beginDate!, endDate!)
        let entity = NSEntityDescription.entityForName("Report", inManagedObjectContext: managedObjectContext)
        let sort = NSSortDescriptor(key: "hours", ascending: true)
        let req = NSFetchRequest()
        req.entity = entity
        req.sortDescriptors = [sort]
        req.predicate = predicate
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: req, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        self._fetchedResultsController = aFetchedResultsController
        
        var e: NSError?
        do {
            try self._fetchedResultsController!.performFetch()
        } catch let error as NSError {
            e = error
            print("Error fetching: \(e?.localizedDescription)")
            abort()
        }
        
        return self._fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController?
    
    // Initial load
    
    override func viewDidLoad() {
        
        if let monthTitle: Int? = self.month {
            let format = NSDateFormatter()
            format.dateFormat = "MMMM yyyy"
            let cal = NSCalendar.currentCalendar()
            let today = cal.components([.Year, .Month], fromDate: NSDate())
            today.month = monthTitle!
            self.monthTitle.text = format.stringFromDate(cal.dateFromComponents(today)!)
        }
    }
    
    // Report logic inside event
    
    override func viewWillAppear(animated: Bool) {
        var hours = 0, books = 0, minutes = 0, magazines = 0, brochures = 0, return_visits = 0, bible_studies = 0
        
        let reports = self.fetchedResultsController.fetchedObjects as! [Report]
        
        for r in reports {
            if let timeOnTheMinistry = r.time() {
                hours += timeOnTheMinistry.hour
                minutes += timeOnTheMinistry.minute
            }
            if minutes >= 60 {
                hours++
                minutes -= 60
            }
            if r.books != nil {
                books += r.books as! Int
            }
            if r.magazines != nil {
                magazines += r.magazines as! Int
            }
            if r.brochures != nil {
                brochures += r.brochures as! Int
            }
            if r.return_visits != nil {
                return_visits += r.return_visits as! Int
            }
            if r.bible_studies != nil {
                bible_studies += r.bible_studies as! Int
            }
        }
        
        self.hoursLabel.text = minutes > 0 ? "\(hours)h \(minutes)min" : "\(hours)h"
        self.booksLabel.text = String(books)
        self.magazinesLabel.text = String(magazines)
        self.brochuresLabel.text = String(brochures)
        self.returnVisitsLabel.text = String(return_visits)
        self.bibleStudiesLabel.text = String(bible_studies)
    }
    
    // TableView update events
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
