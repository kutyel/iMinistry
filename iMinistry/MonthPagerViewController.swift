//
//  MonthPagerViewController.swift
//  iMinistry
//
//  Created by Flavio Corpa on 10/03/15.
//  Copyright (c) 2015 Flavio Corpa. All rights reserved.
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
        
        let month = NSCalendar.currentCalendar().components(.CalendarUnitMonth, fromDate: NSDate()).month
        let startingViewController: MonthTableViewController = self.modelController.viewControllerAtIndex(find(self.modelController.pageData, month)!, storyboard: self.storyboard!)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })
        
        self.pageViewController!.dataSource = self.modelController
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        
        var pageViewRect = self.view.bounds
        self.pageViewController!.view.frame = pageViewRect
        
        if (self.respondsToSelector(Selector("edgesForExtendedLayout"))) {
            self.edgesForExtendedLayout = UIRectEdge.None
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
        let currentViewController = self.pageViewController!.viewControllers[0] as! UIViewController
        let viewControllers = [currentViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })
        
        self.pageViewController!.doubleSided = false
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
        let month = calendar.components(.CalendarUnitMonth, fromDate: NSDate()).month
        let index = find(self.modelController.pageData, month)!
        let monthTitle = self.modelController.pageData[index]
        let format = NSDateFormatter()
        format.dateFormat = "MMMM yyyy"
        
        var today = calendar.components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: NSDate())
        today.month = monthTitle
        
        for report in reports {
            
            if calendar.components(.CalendarUnitMonth, fromDate: report.date).month == monthTitle {
                if report.hours != nil {
                    let startOfTheDay = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: report.hours!, options: nil)
                    let timeOnTheMinistry = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: startOfTheDay!, toDate: report.hours!, options: nil)
                    
                    hours += timeOnTheMinistry.hour
                    minutes += timeOnTheMinistry.minute
                    
                    if minutes >= 60 {
                        hours++
                        minutes -= 60
                    }
                }
                if report.books != nil {
                    books += report.books as! Int
                }
                if report.magazines != nil {
                    magazines += report.magazines as! Int
                }
                if report.brochures != nil {
                    brochures += report.brochures as! Int
                }
                if report.return_visits != nil {
                    return_visits += report.return_visits as! Int
                }
                if report.bible_studies != nil {
                    bible_studies += report.bible_studies as! Int
                }
            }
        }
        
        var report = "Report for \(format.stringFromDate(calendar.dateFromComponents(today)!))\n"
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
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if segue.identifier == "AddReport" {
            let managedObjectContext = appDelegate.managedObjectContext!
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
