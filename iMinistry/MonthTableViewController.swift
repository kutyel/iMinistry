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
        let managedObjectContext = appDelegate.managedObjectContext!
        
        // Query the reports for the current month
        
        let cal = NSCalendar.currentCalendar()
        var com = cal.components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: NSDate())
        com.day = 1
        
        if let obj: Int = month {
            com.month = obj
        }
        
        var one = NSDateComponents()
        one.month = 1
    
        let beginDate = cal.dateFromComponents(com)
        let endDate = cal.dateByAddingComponents(one, toDate: beginDate!, options: nil)
        
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", beginDate!, endDate!);
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
        if !self._fetchedResultsController!.performFetch(&e) {
            println("Error fetching: \(e?.localizedDescription)")
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
            var today = cal.components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: NSDate())
            today.month = monthTitle!
            self.monthTitle.text = format.stringFromDate(cal.dateFromComponents(today)!)
        }
        
        //TODO: this can be loaded at the storyboard
        self.hoursLabel.textAlignment = .Right
        self.booksLabel.textAlignment = .Right
        self.magazinesLabel.textAlignment = .Right
        self.brochuresLabel.textAlignment = .Right
        self.returnVisitsLabel.textAlignment = .Right
        self.bibleStudiesLabel.textAlignment = .Right
    }
    
    // Report logic inside event
    
    override func viewWillAppear(animated: Bool) {
        var hours = 0
        var books = 0
        var minutes = 0
        var magazines = 0
        var brochures = 0
        var return_visits = 0
        var bible_studies = 0
        
        let reports = self.fetchedResultsController.fetchedObjects as! [Report]
        
        let calendar = NSCalendar.currentCalendar()
        
        for r in reports {
            if let timeOnTheMinistry = r.time() {
                hours += timeOnTheMinistry.hour
                minutes += timeOnTheMinistry.minute
                if minutes >= 60 {
                    hours++
                    minutes -= 60
                }
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
