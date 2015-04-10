//
//  AnualReportChartViewController.swift
//  iMinistry
//
//  Created by Flavio Corpa on 06/04/15.
//  Copyright (c) 2015 Flavio Corpa. All rights reserved.
//

import UIKit

class AnualReportChartViewController: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {
    
    let order = [ 9, 10, 11, 12, 1, 2, 3, 4, 5, 6, 7, 8 ]
    let staticData: [CGFloat] = [ 50, 60, 70, 45, 30, 35, 60, 65, 75, 35, 70, 50 ]
    
    // Constants
    
    let π = CGFloat(M_PI)
    let anualReportNumBars: UInt = 12
    let anualReportsChart = JBBarChartView()
    let anualReportNavButtonViewKey = "view"
    let anualReportBarPadding: CGFloat = 1.0
    let anualReportChartHeight: CGFloat = 250.0
    let anualReportChartPadding: CGFloat = 10.0
    let anualReportChartHeaderHeight: CGFloat = 80.0
    let anualReportChartHeaderPadding: CGFloat = 20.0
    let anualReportChartFooterHeight: CGFloat = 25.0
    let anualReportChartFooterPadding: CGFloat = 5.0
    let monthSymbols = NSDateFormatter().shortMonthSymbols
    
    // View Creation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.respondsToSelector(Selector("edgesForExtendedLayout"))) {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Continue", style: .Plain, target: self, action: "chartToggleButtonPressed:")
        
        anualReportsChart.dataSource = self
        anualReportsChart.delegate = self
        anualReportsChart.minimumValue = 0
        anualReportsChart.headerPadding = anualReportChartHeaderPadding
        anualReportsChart.frame = CGRectMake(anualReportChartPadding, anualReportChartPadding, self.view.bounds.size.width - (anualReportChartPadding * 2), anualReportChartHeight)
        
        var header = iMinistryHeaderView(frame: CGRectMake(anualReportChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(anualReportChartHeaderHeight * 0.5), self.view.bounds.size.width - (anualReportChartPadding * 2), anualReportChartHeaderHeight))
        header.titleLabel.text = "SERVICE YEAR"
        header.subtitleLabel.text = "2014-2015"
        header.separatorColor = UIColor.lightGrayColor()
        anualReportsChart.headerView = header
        
        var footer = iMinistryFooterView(frame: CGRectMake(anualReportChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(anualReportChartFooterHeight * 0.5), self.view.bounds.size.width - (anualReportChartPadding * 2), anualReportChartFooterHeight))
        footer.padding = anualReportChartFooterPadding
        footer.leftLabel.text = monthSymbols[8].uppercaseString
        footer.rightLabel.text = monthSymbols[7].uppercaseString
        anualReportsChart.footerView = footer
        
        self.view.addSubview(anualReportsChart)
        anualReportsChart.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Bar Chart Methods
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        return self.anualReportNumBars
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        // TODO: this is the key line when implementing the real data for the service year
        // let index = find(order, r.month())!
        return self.staticData[Int(index)]
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
        let btnImageView = self.navigationItem.rightBarButtonItem?.valueForKey(anualReportNavButtonViewKey) as UIView
        btnImageView.userInteractionEnabled = false
        
        let transform = self.anualReportsChart.state == JBChartViewState.Expanded ? CGAffineTransformMakeRotation(π) : CGAffineTransformMakeRotation(0)
        btnImageView.transform = transform
        
        self.anualReportsChart.setState(self.anualReportsChart.state == JBChartViewState.Expanded ? JBChartViewState.Collapsed : JBChartViewState.Expanded, animated: true, callback: {
            btnImageView.userInteractionEnabled = true
        })
    }
}
