//
//  iMinistryTooltipTipView.swift
//  iMinistry
//
//  Created by Flavio Corpa on 17/04/15.
//  Copyright © 2015 Flavio Corpa. All rights reserved.
//

import UIKit

class iMinistryTooltipTipView: UIView {
    
    let iMinistryTooltipViewDefaultWidth: CGFloat = 8.0
    let iMinistryTooltipViewDefaultHeight: CGFloat = 5.0
    
    override init(frame: CGRect) {
        super.init(frame: CGRectMake(0, 0, iMinistryTooltipViewDefaultWidth, iMinistryTooltipViewDefaultHeight))
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func drawRect(rect: CGRect) {
        UIColor.whiteColor().set()
        let ctx = UIGraphicsGetCurrentContext()
        CGContextFillRect(ctx, rect)
        CGContextSaveGState(
        {
            CGContextBeginPath(ctx)
            CGContextMoveToPoint(ctx, CGRectGetMidX(rect), CGRectGetMaxY(rect))
            CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect))
            CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect))
            CGContextClosePath(ctx)
            CGContextSetFillColorWithColor(ctx, UIColor.lightGrayColor().CGColor)
            CGContextFillPath(ctx)
            return ctx
        }())
        CGContextRestoreGState(ctx)
    }
}
