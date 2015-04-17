//
//  AnualReportChartBaseController.swift
//  iMinistry
//
//  Created by Flavio Corpa on 17/04/15.
//  Copyright © 2015 Flavio Corpa. All rights reserved.
//

import UIKit

class AnualReportChartBaseController: UIViewController {

    let iMinistryChartAnimationDuration: NSTimeInterval = 0.25
    
    var anualReportsChart: JBBarChartView?
    var tooltipView: iMinistryTooltipView?
    var tooltipTipView: iMinistryTooltipTipView?

    func setTooltipVisible(visible: Bool, animated: Bool, touchPoint: CGPoint){
        
        var chartView = anualReportsChart
        
        if (tooltipView == nil) {
            tooltipView = iMinistryTooltipView()
            tooltipView!.alpha = 0.0
            self.view.addSubview(tooltipView!)
            self.view.bringSubviewToFront(tooltipView!)
        }
        
        if (tooltipTipView == nil) {
            tooltipTipView = iMinistryTooltipTipView()
            tooltipTipView!.alpha = 0.0
            self.view.addSubview(tooltipTipView!)
            self.view.bringSubviewToFront(tooltipTipView!)
        }
            
        let adjustTooltipVisibility = {() -> () in
            self.tooltipView?.alpha = visible ? 1.0 : 0.0
            self.tooltipTipView?.alpha = visible ? 1.0 : 0.0
        }
        
        let adjustTooltipPosition = {() -> () in
            var originalPoint = self.view.convertPoint(touchPoint, fromView: chartView)
            var convertedPoint = originalPoint
            
            if var chartView = chartView {
                let minChartX = (chartView.frame.origin.x + ceil(self.tooltipView!.frame.size.width * 0.5))
                if (convertedPoint.x < minChartX) { convertedPoint.x = minChartX }
                let maxChartX = (chartView.frame.origin.x + chartView.frame.size.width - ceil(self.tooltipView!.frame.size.width * 0.5))
                if (convertedPoint.x > maxChartX) { convertedPoint.x = maxChartX }
                self.tooltipView!.frame = CGRectMake(convertedPoint.x - ceil(self.tooltipView!.frame.size.width * 0.5), CGRectGetMaxY(chartView.headerView.frame), self.tooltipView!.frame.size.width, self.tooltipView!.frame.size.height)
                
                let minTipX = (chartView.frame.origin.x + ceil(self.tooltipTipView!.frame.size.width))
                if (originalPoint.x < minTipX) { originalPoint.x = minTipX }
                let maxTipX = (chartView.frame.origin.x + chartView.frame.size.width - self.tooltipTipView!.frame.size.width)
                if (originalPoint.x > maxTipX) { originalPoint.x = maxTipX }
                self.tooltipTipView!.frame = CGRectMake(originalPoint.x - ceil(self.tooltipTipView!.frame.size.width * 0.5), CGRectGetMaxY(self.tooltipView!.frame), self.tooltipTipView!.frame.size.width, self.tooltipTipView!.frame.size.height)
            }
        }
        
        if (visible){
            adjustTooltipPosition()
        }
        
        if (animated){
            UIView.animateWithDuration(iMinistryChartAnimationDuration, animations: {
                adjustTooltipVisibility()
            }, completion: { finished in
                if (!visible){
                    adjustTooltipVisibility()
                }
            })
        }
        else {
            adjustTooltipVisibility()
        }
    }
    
    func setTooltipVisible(visible: Bool, animated: Bool) {
        self.setTooltipVisible(visible, animated: animated, touchPoint: CGPointZero)
    }
    
    func setTooltipVisible(visible: Bool) {
        self.setTooltipVisible(visible, animated: false)
    }
    
}
