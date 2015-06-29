//
//  MonthModelController.swift
//  iMinistry
//
//  Created by Flavio Corpa on 29/03/15.
//  Copyright © 2015 Flavio Corpa. All rights reserved.
//

import UIKit
import CoreData

class MonthModelController: NSObject, NSFetchedResultsControllerDelegate, UIPageViewControllerDataSource {
    
    var pageData: [Int] = []
    var managedObjectContext: NSManagedObjectContext?
    let month = NSCalendar.currentCalendar().components(.Month, fromDate: NSDate()).month
    
    override init() {
        super.init()
        
        let reports = self.fetchedResultsController.fetchedObjects as! [Report]
        
        for r in reports {
            let m = r.month()
            if !self.pageData.contains(m) {
                pageData.append(m)
            }
        }
        
        if !self.pageData.contains(month) {
            pageData.append(month)
        }
    }
    
    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> MonthTableViewController? {
        if (self.pageData.count == 0) || (index >= self.pageData.count) {
            return nil
        }
        
        let dataViewController = storyboard.instantiateViewControllerWithIdentifier("MonthContentController") as! MonthTableViewController        
        dataViewController.month = self.pageData[index]
        dataViewController.managedObjectContext = self.managedObjectContext
        return dataViewController
    }
    
    func indexOfViewController(viewController: MonthTableViewController) -> Int {
        if let dataObject: Int = viewController.month {
            return self.pageData.indexOf(dataObject)!
        } else {
            return NSNotFound
        }
    }
    
    // Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! MonthTableViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        index--
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! MonthTableViewController)
        if index == NSNotFound {
            return nil
        }
        index++
        if index == self.pageData.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    // Page Control Config
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageData.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageData.indexOf(month)!
    }
    
    // Core Data
    
    var fetchedResultsController: NSFetchedResultsController {
        
        if self._fetchedResultsController != nil {
            return self._fetchedResultsController!
        }
        
        // Set the initial managed object context to the app delegate one
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        // Query the reports for the current month
        
        let entity = NSEntityDescription.entityForName("Report", inManagedObjectContext: managedObjectContext)
        let sort = NSSortDescriptor(key: "date", ascending: true)
        let req = NSFetchRequest()
        req.entity = entity
        req.sortDescriptors = [sort]
        
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
}