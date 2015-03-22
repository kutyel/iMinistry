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
    
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var booksLabel: UILabel!
    @IBOutlet var magazinesLabel: UILabel!
    @IBOutlet var brochuresLabel: UILabel!
    @IBOutlet var returnVisitsLabel: UILabel!
    @IBOutlet var bibleStudiesLabel: UILabel!
    
    // Query to Core Data
    
    var fetchedResultsController: NSFetchedResultsController {
        
        if self._fetchedResultsController != nil {
            return self._fetchedResultsController!
        }
        
        let managedObjectContext = self.managedObjectContext!
        
        // Query the reports for the current month
        
        let cal = NSCalendar.currentCalendar()
        var com = cal.components(.YearCalendarUnit | .MonthCalendarUnit, fromDate: NSDate())
        com.day = 1
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
        
        self.hoursLabel.textAlignment = .Right
        self.booksLabel.textAlignment = .Right
        self.magazinesLabel.textAlignment = .Right
        self.brochuresLabel.textAlignment = .Right
        self.returnVisitsLabel.textAlignment = .Right
        self.bibleStudiesLabel.textAlignment = .Right
        
        let format = NSDateFormatter()
        format.dateFormat = "MMMM yyyy"
        self.title = format.stringFromDate(NSDate())
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
        
        let reports = self.fetchedResultsController.fetchedObjects as [Report]
        let calendar = NSCalendar.currentCalendar()
        
        for report in reports {
            
            if report.hours != nil {
                let startOfTheDay = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: report.hours!, options: nil)
                let timeOnTheMinistry = calendar.components(.HourCalendarUnit | .MinuteCalendarUnit, fromDate: startOfTheDay!, toDate: report.hours!, options: nil)
                
                hours += timeOnTheMinistry.hour
                minutes += timeOnTheMinistry.minute
                
                if minutes >= 60 {
                    hours++
                    minutes -= 60
                }
            }
            if report.books != nil {
                books += report.books as Int
            }
            if report.magazines != nil {
                magazines += report.magazines as Int
            }
            if report.brochures != nil {
                brochures += report.brochures as Int
            }
            if report.return_visits != nil {
                return_visits += report.return_visits as Int
            }
            if report.bible_studies != nil {
                bible_studies += report.bible_studies as Int
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
    
    // Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AddReport" {
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
}
