//
//  AnualReportChartViewController.swift
//  iMinistry
//
//  Created by Flavio Corpa on 06/04/15.
//  Copyright (c) 2015 Flavio Corpa. All rights reserved.
//

import UIKit

class AnualReportChartViewController: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {

    let staticData: [CGFloat] = [ 50, 60, 70, 45, 30, 10, 70, 80, 75, 35, 70, 25 ]
    
    // Constants
    
    let anualReportChartHeight: CGFloat = 250.0
    let anualReportChartPadding: CGFloat = 10.0
    let kanualReportChartHeaderHeight: CGFloat = 80.0
    let anualReportChartHeaderPadding: CGFloat = 20.0
    let anualReportChartFooterHeight: CGFloat = 25.0
    let anualReportChartFooterPadding: CGFloat = 5.0
    let anualReportBarPadding: CGFloat = 1.0
    let anualReportNumBars: UInt = 12
    let anualReportMaxBarHeight: UInt = 10
    let anualReportMinBarHeight: UInt = 5
    let monthSymbols = NSDateFormatter().monthSymbols
    
    // View Creation
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // JBBarChartView
        
        let anualReportsChart = JBBarChartView()
        anualReportsChart.dataSource = self
        anualReportsChart.delegate = self
        anualReportsChart.frame = CGRectMake(anualReportChartPadding, anualReportChartPadding, self.view.bounds.size.width - (anualReportChartPadding * 2), anualReportChartHeight)
        
        // JBBarChartFooterView 
        /*
        let chartFooter = UIView(frame: CGRectMake(anualReportChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(anualReportChartFooterHeight * 0.5), self.view.bounds.size.width - (anualReportChartPadding * 2), anualReportChartFooterHeight))
        chartFooter.padding = anualReportChartFooterPadding;
        chartFooter.leftLabel.text = monthSymbols.first().uppercaseString
        chartFooter.leftLabel.textColor = UIColor.lightGrayColor()
        chartFooter.rightLabel.text = monthSymbols.last().uppercaseString
        chartFooter.rightLabel.textColor = UIColor.lightGrayColor()
        anualReportsChart.footerView = chartFooter
        */
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
        // TODO this must be the actual report data
        return self.staticData[Int(index)]
    }
    
    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
        return UIColor.blueColor()
    }
}
