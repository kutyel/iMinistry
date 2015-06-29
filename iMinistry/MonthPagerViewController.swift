//
//  MonthPagerViewController.swift
//  iMinistry
//
//  Created by Flavio Corpa on 10/03/15.
//  Copyright © 2015 Flavio Corpa. All rights reserved.
//

import UIKit
import CoreData

class MonthPagerViewController: UIViewController, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.delegate = self
        
        // Load first the page view of the current month
        
        let month = NSCalendar.currentCalendar().components(.Month, fromDate: NSDate()).month
        let startingViewController: MonthTableViewController = self.modelController.viewControllerAtIndex(self.modelController.pageData.indexOf(month)!, storyboard: self.storyboard!)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })
        
        self.pageViewController!.dataSource = self.modelController
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        
        let pageViewRect = self.view.bounds
        self.pageViewController!.view.frame = pageViewRect
        
        if (self.respondsToSelector(Selector("edgesForExtendedLayout"))) {
            self.edgesForExtendedLayout = .None
        }
        
        self.pageViewController!.didMoveToParentViewController(self)
        
        self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
        
        // Dynamically generate buttons
        
        let share = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareReport:")
        let addReport = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addReport:")
        
        self.navigationItem.rightBarButtonItems = [addReport, share]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var modelController: MonthModelController {
        if _monthModelController == nil {
            _monthModelController = MonthModelController()
        }
        return _monthModelController!
    }
    
    var _monthModelController: MonthModelController? = nil
    
    // UIPageViewController delegate methods
    
    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        if let currentViewController = self.pageViewController!.viewControllers?[0] {
            let viewControllers = [currentViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })
            self.pageViewController!.doubleSided = false
        }
        return .Min
    }
    
    // Actions
    
    func addReport(sender: UIBarButtonItem)
    {
        self.performSegueWithIdentifier("AddReport", sender: sender)
    }
    
    func shareReport(sender: UIBarButtonItem)
    {
        var hours = 0
        var books = 0
        var minutes = 0
        var magazines = 0
        var brochures = 0
        var return_visits = 0
        var bible_studies = 0
        let reports = self.modelController.fetchedResultsController.fetchedObjects as! [Report]
        let calendar = NSCalendar.currentCalendar()
        let month = self.modelController.month
        let format = NSDateFormatter()
        format.dateFormat = "MMMM yyyy"
        
        let title = calendar.components([.Year, .Month], fromDate: NSDate())
        title.month = month
        
        for r in reports {
            if r.month() == month {
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
        }
        
        var report = "Report for \(format.stringFromDate(calendar.dateFromComponents(title)!))\n"
        report += "Books & Sign-Language Videos: \(books)\n"
        report += "Brochures & Tracts: \(brochures)\n"
        report += "Hours: \(hours)\n"
        report += "Magazines: \(magazines)\n"
        report += "Return Visits: \(return_visits)\n"
        report += "Different Bible Studies: \(bible_studies)\n"
        report += "Report generated by iMinistry."
        
        let activity = UIActivityViewController(activityItems: Array(arrayLiteral: report), applicationActivities: nil)
        self.presentViewController(activity, animated: true, completion: nil)
    }
    
    // Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if segue.identifier == "AddReport" {
            let managedObjectContext = appDelegate.managedObjectContext
            let report = NSEntityDescription.insertNewObjectForEntityForName("Report", inManagedObjectContext: managedObjectContext) as! Report
            let nav = segue.destinationViewController as! UINavigationController
            let add = nav.topViewController as! AddReportTableViewController
            add.report = report
            add.didCancel = {
                cont in self.dismissViewControllerAnimated(true, completion: nil)
            }
            add.didFinish = {
                cont in self.dismissViewControllerAnimated(true, completion: nil)
            }
        } else if segue.identifier == "RecentReports" {
            let next = segue.destinationViewController as! RecentReportsViewController
            next.managedObjectContext = appDelegate.managedObjectContext
        }
    }
    
}
