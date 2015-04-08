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
    
    let anualReportNumBars: UInt = 12
    let anualReportChartHeight: CGFloat = 250.0
    let anualReportChartPadding: CGFloat = 10.0
    let anualReportChartHeaderHeight: CGFloat = 80.0
    let anualReportChartHeaderPadding: CGFloat = 20.0
    let anualReportChartFooterHeight: CGFloat = 25.0
    let anualReportChartFooterPadding: CGFloat = 5.0
    let anualReportBarPadding: CGFloat = 1.0
    let monthSymbols = NSDateFormatter().shortMonthSymbols
    
    // View Creation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let anualReportsChart = JBBarChartView()
        anualReportsChart.dataSource = self
        anualReportsChart.delegate = self
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
        footer.leftLabel.textColor = UIColor.lightGrayColor()
        footer.rightLabel.text = monthSymbols[7].uppercaseString
        footer.rightLabel.textColor = UIColor.lightGrayColor()
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
        // TODO this must be the actual report data
        return self.staticData[Int(index)]
    }
    
    // Chart Customization
    
    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
        return colorFromHex(0x4a6da7) // JW.ORG
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        return self.anualReportBarPadding
    }
    
    func colorFromHex(hex: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((hex & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((hex & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(hex & 0xFF))/255.0, alpha: 1.0)
    }
}
