//
//  RecentReportsViewController.swift
//  iMinistry
//
//  Created by Flavio Corpa on 02/03/15.
//  Copyright © 2015 Flavio Corpa. All rights reserved.
//

import UIKit
import CoreData

class RecentReportsViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var managedObjectContext: NSManagedObjectContext?
    
    var fetchedResultsController: NSFetchedResultsController {
    
        if self._fetchedResultsController != nil {
            return self._fetchedResultsController!
        }
    
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = delegate.managedObjectContext!
    
        // Query all the reports descending by date
    
        let entity = NSEntityDescription.entityForName("Report", inManagedObjectContext: managedObjectContext)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        let req = NSFetchRequest()
        req.entity = entity
        req.sortDescriptors = [sort]
        //req.propertiesToGroupBy = [Array(arrayLiteral: group)]
    
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: req, managedObjectContext: managedObjectContext, sectionNameKeyPath: "week", cacheName: nil)
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
        return self.fetchedResultsController.sections!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var hours = 0
        var minutes = 0
        let calendar = NSCalendar.currentCalendar()
        let reports = self.fetchedResultsController.fetchedObjects as! [Report]
        let info = self.fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        for r in reports {
            if r.week() == info.name?.toInt() {
                if let timeOnTheMinistry = r.time() {
                    hours += timeOnTheMinistry.hour
                    minutes += timeOnTheMinistry.minute
                    if minutes >= 60 {
                        hours++
                        minutes -= 60
                    }
                }
            }
        }
        return minutes > 0 ? "Week \(info.name!) (\(hours)h \(minutes)min)" : "Week \(info.name!) (\(hours)h)"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let info = self.fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return info.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reportCell", forIndexPath:indexPath) as! UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    // This allows the user to delete reports
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle:
        UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let report = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        fetchedResultsController.managedObjectContext.deleteObject(report)
        fetchedResultsController.managedObjectContext.save(nil)
    }
    
    // Private function to configure the cell to the model

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let report = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Report
        
        // The title is the date
        let format = NSDateFormatter()
        format.dateFormat = "EEEE, d MMMM yyyy"
        cell.textLabel?.text = format.stringFromDate(report.date)
        
        // The subtitle is the report's highlights
        var highlights: [String] = [];
        if let timeOnTheMinistry = report.time() {
            if timeOnTheMinistry.hour > 0 {
                highlights.append("\(timeOnTheMinistry.hour) hours")
            }
            if timeOnTheMinistry.minute > 0 {
                highlights.append("\(timeOnTheMinistry.minute) minutes")
            }
        }
        if let tracts = report.brochures as? Int {
            highlights.append("\(tracts) tracts")
        }
        if let returns = report.return_visits as? Int {
            highlights.append("\(returns) return visits")
        }
        cell.detailTextLabel?.text = ", ".join(highlights.map { $0 })
    }

    // Results Controller Delegate

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
            case .Insert:
                self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Update:
                let cell = self.tableView.cellForRowAtIndexPath(indexPath!)
                self.configureCell(cell!, atIndexPath: indexPath!)
                self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Move:
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if segue.identifier == "EditReport" {
            let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)
            let report = self.fetchedResultsController.objectAtIndexPath(indexPath!) as! Report
            let nav = segue.destinationViewController as! UINavigationController
            let edit = nav.topViewController as! AddReportTableViewController
            edit.report = report
            edit.didCancel = {
                cont in self.dismissViewControllerAnimated(true, completion: nil)
            }
            edit.didFinish = {
                cont in self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        else if segue.identifier == "AnualReports" {
            let anualChart = segue.destinationViewController as! AnualReportChartViewController
            anualChart.managedObjectContext = appDelegate.managedObjectContext
        }
    }
}
