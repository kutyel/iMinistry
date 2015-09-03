//
//  AnualReportChartViewController.swift
//  iMinistry
//
//  Created by Flavio Corpa on 06/04/15.
//  Copyright © 2015 Flavio Corpa. All rights reserved.
//

import UIKit
import CoreData

class AnualReportChartViewController: AnualReportChartBaseController, NSFetchedResultsControllerDelegate, JBBarChartViewDelegate, JBBarChartViewDataSource {
    
    var informationView = iMinistryInformationView()
    var data = [Int](count: 12, repeatedValue: 0)
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        
        let reports = self.fetchedResultsController.fetchedObjects as! [Report]
        
        for r in reports {
            data[order.indexOf(r.month())!] += r.time()!.hour
        }
    }
    
    // Constants
    
    let π = CGFloat(M_PI)
    let anualReportNumBars: UInt = 12
    let anualReportNavButtonViewKey = "view"
    let anualReportBarPadding: CGFloat = 1.0
    let anualReportChartHeight: CGFloat = 250.0
    let anualReportChartPadding: CGFloat = 10.0
    let anualReportChartHeaderHeight: CGFloat = 80.0
    let anualReportChartHeaderPadding: CGFloat = 20.0
    let anualReportChartFooterHeight: CGFloat = 25.0
    let anualReportChartFooterPadding: CGFloat = 5.0
    let order = [ 9, 10, 11, 12, 1, 2, 3, 4, 5, 6, 7, 8 ]
    let monthSymbols = NSDateFormatter().shortMonthSymbols
    
    // View Creation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.respondsToSelector(Selector("edgesForExtendedLayout"))) {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-arrow"), style: .Plain, target: self, action: "chartToggleButtonPressed:")
        
        anualReportsChart = JBBarChartView()
        anualReportsChart!.dataSource = self
        anualReportsChart!.delegate = self
        anualReportsChart!.minimumValue = 0
        anualReportsChart!.headerPadding = anualReportChartHeaderPadding
        anualReportsChart!.frame = CGRectMake(anualReportChartPadding, anualReportChartPadding, self.view.bounds.size.width - (anualReportChartPadding * 2), anualReportChartHeight)
        
        let header = iMinistryHeaderView(frame: CGRectMake(anualReportChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(anualReportChartHeaderHeight * 0.5), self.view.bounds.size.width - (anualReportChartPadding * 2), anualReportChartHeaderHeight))
        header.titleLabel.text = "SERVICE YEAR"
        header.subtitleLabel.text = "2014-2015"
        header.separatorColor = UIColor.lightGrayColor()
        anualReportsChart!.headerView = header
        
        let footer = iMinistryFooterView(frame: CGRectMake(anualReportChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(anualReportChartFooterHeight * 0.5), self.view.bounds.size.width - (anualReportChartPadding * 2), anualReportChartFooterHeight))
        footer.padding = anualReportChartFooterPadding
        footer.leftLabel.text = monthSymbols[8].uppercaseString
        footer.rightLabel.text = monthSymbols[7].uppercaseString
        anualReportsChart!.footerView = footer
        
        informationView = iMinistryInformationView(frame: CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(self.anualReportsChart!.frame), self.view.bounds.size.width, self.view.bounds.height - CGRectGetMaxY(self.anualReportsChart!.frame) - CGRectGetMaxY(self.navigationController!.navigationBar.frame)))
        
        self.view.addSubview(informationView)
        self.view.addSubview(anualReportsChart!)
        
        anualReportsChart!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Bar Chart Methods
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        return anualReportNumBars
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        return CGFloat(data[Int(index)])
    }
    
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt, touchPoint: CGPoint) {
        informationView.setValueText(Int(data[Int(index)]).description, unit: "h")
        informationView.setTitle("Total Month Hours")
        informationView.setHidden(false, animated: true)
        self.setTooltipVisible(true, animated: true, touchPoint: touchPoint)
        self.tooltipView?.setText(monthSymbols[order[Int(index)] - 1].uppercaseString)
    }
    
    func didDeselectBarChartView(barChartView: JBBarChartView!) {
        informationView.setHidden(true, animated: true)
        self.setTooltipVisible(false, animated: true)
    }
    
    // Chart Customization
    
    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
        return index % 2 == 0 ? colorFromHex(0x4a6da7) : colorFromHex(0x5b398b) // JW.ORG
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        return self.anualReportBarPadding
    }
    
    func colorFromHex(hex: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((hex & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((hex & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(hex & 0xFF))/255.0, alpha: 1.0)
    }
    
    // Buttons
    
    func chartToggleButtonPressed(sender: UIBarButtonItem) {
        let btnImageView = self.navigationItem.rightBarButtonItem?.valueForKey(anualReportNavButtonViewKey) as! UIView
        btnImageView.userInteractionEnabled = false
        let transform = self.anualReportsChart!.state == JBChartViewState.Expanded ? CGAffineTransformMakeRotation(π) : CGAffineTransformMakeRotation(0)
        btnImageView.transform = transform
        /*
        let pop = UIPopoverController(contentViewController: MonthTableViewController())
        pop.delegate = self
        popServiceYear = pop
        popServiceYear?.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: .Any, animated: true)
        */
        self.anualReportsChart!.setState(self.anualReportsChart!.state == JBChartViewState.Expanded ? JBChartViewState.Collapsed : JBChartViewState.Expanded, animated: true, callback: {
            btnImageView.userInteractionEnabled = true
        })
    }
    
    // Core Data
    
    var managedObjectContext: NSManagedObjectContext?
    
    var fetchedResultsController: NSFetchedResultsController {
        
        if self._fetchedResultsController != nil {
            return self._fetchedResultsController!
        }
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = delegate.managedObjectContext
        
        // TODO: Query all the reports for the selected service year
        //let predicate = NSPredicate(format: "date >= %@ AND date < %@", beginDate!, endDate!)
        let entity = NSEntityDescription.entityForName("Report", inManagedObjectContext: managedObjectContext)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        let req = NSFetchRequest()
        req.entity = entity
        req.sortDescriptors = [sort]
        //req.predicate = predicate
        
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
