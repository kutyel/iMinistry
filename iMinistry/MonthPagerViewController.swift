//
//  MonthPagerViewController.swift
//  iMinistry
//
//  Created by Flavio Corpa on 10/03/15.
//  Copyright (c) 2015 Flavio Corpa. All rights reserved.
//

import UIKit

class MonthPagerViewController: UIViewController, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.delegate = self
        
        let startingViewController: MonthTableViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
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
        let currentViewController = self.pageViewController!.viewControllers[0] as UIViewController
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
        // TODO: implement this with the report details
        let report = "Here is where all the report items go..."
        let activity = UIActivityViewController(activityItems: Array(arrayLiteral: report), applicationActivities: nil)
        self.presentViewController(activity, animated: true, completion: nil)
    }
}
