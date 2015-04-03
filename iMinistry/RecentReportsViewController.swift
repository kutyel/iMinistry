//
//  RecentReportsViewController.swift
//  iMinistry
//
//  Created by Flavio Corpa on 02/03/15.
//  Copyright (c) 2015 Flavio Corpa. All rights reserved.
//

import UIKit
import CoreData

class RecentReportsViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // Weeks and # of reports for each week
    var weeks: [Int:Int] = [:]
    var index = 0
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        let calendar = NSCalendar.currentCalendar()
        let reports = self.fetchedResultsController.fetchedObjects as [Report]
        
        for r in reports {
            let week = calendar.components(.WeekOfYearCalendarUnit, fromDate: r.date).weekOfYear
            if let weekItem: Int = weeks[week] {
                weeks[week] = weekItem + 1
            } else {
                weeks[week] = 1
            }
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController {
    
        if self._fetchedResultsController != nil {
            return self._fetchedResultsController!
        }
    
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedObjectContext = delegate.managedObjectContext!
    
        // Query all the reports descending by date
    
        let entity = NSEntityDescription.entityForName("Report", inManagedObjectContext: managedObjectContext)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        let req = NSFetchRequest()
        req.entity = entity
        req.sortDescriptors = [sort]
        //req.propertiesToGroupBy = [Array(arrayLiteral: group)]
    
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

    // TableView Data Source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return weeks.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var hours = 0
        let calendar = NSCalendar.currentCalendar()
        let reports = self.fetchedResultsController.fetchedObjects as [Report]
        for r in reports {
            let week = calendar.components(.WeekOfYearCalendarUnit, fromDate: r.date).weekOfYear
            if week == Array(weeks.keys)[section]{
                if r.hours != nil {
                    let startOfTheDay = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: reports[section].hours!, options: nil)
                    let timeOnTheMinistry = calendar.components(.HourCalendarUnit | .MinuteCalendarUnit, fromDate: startOfTheDay!, toDate: reports[section].hours!, options: nil)
                    hours += timeOnTheMinistry.hour
                }
            }
        }
        return "Week \(Array(weeks.keys).sorted(>)[section]) (\(hours)h)"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(weeks.values)[section]
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reportCell", forIndexPath:indexPath) as UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    // This allows the user to delete reports
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle:
        UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let report = fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
        fetchedResultsController.managedObjectContext.deleteObject(report)
        fetchedResultsController.managedObjectContext.save(nil)
    }
    
    // Private function to configure the cell to the model

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let reports = self.fetchedResultsController.fetchedObjects as [Report]
        let report = reports[index]
        
        // The title is the date
        let format = NSDateFormatter()
        format.dateFormat = "EEEE, d MMMM yyyy"
        cell.textLabel?.text = format.stringFromDate(report.date)
        
        // The subtitle is the report's highlights
        var highlights = "";
        if report.hours != nil {
            let calendar = NSCalendar.currentCalendar()
            let startOfTheDay = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: report.hours!, options: nil)
            let timeOnTheMinistry = calendar.components(.HourCalendarUnit | .MinuteCalendarUnit, fromDate: startOfTheDay!, toDate: report.hours!, options: nil)
            
            if timeOnTheMinistry.hour > 0 {
                highlights += "\(timeOnTheMinistry.hour) hours, "
            }
            if timeOnTheMinistry.minute > 0 {
                highlights += "\(timeOnTheMinistry.minute) minutes, "
            }
        }
        if report.magazines != nil {
            var mag = String(report.magazines as Int)
            highlights += "\(mag) magazines..."
        }
        cell.detailTextLabel?.text = highlights
        index++
    }

    // Results Controller Delegate

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
        switch type {
            case .Insert:
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            case .Update:
                let cell = self.tableView.cellForRowAtIndexPath(indexPath)
                self.configureCell(cell!, atIndexPath: indexPath)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case .Move:
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
