//
//  iMinistryFooterView.swift
//  iMinistry
//
//  Created by Flavio Corpa on 07/04/15.
//  Copyright (c) 2015 Flavio Corpa. All rights reserved.
//

import UIKit

class iMinistryFooterView: UIView {
    
    var padding: CGFloat = 0
    var leftLabel = UILabel()
    var rightLabel = UILabel()

    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = footerViewDefaultBackgroundColor
        
        self.padding = footerPolygonViewDefaultPadding
        
        leftLabel = UILabel()
        leftLabel.adjustsFontSizeToFitWidth = true
        leftLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        leftLabel.textAlignment = .Left
        leftLabel.textColor = UIColor.blackColor()
        leftLabel.shadowColor = UIColor.lightGrayColor()
        leftLabel.shadowOffset = CGSizeMake(0, 1)
        leftLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(leftLabel)
        
        rightLabel = UILabel()
        rightLabel.adjustsFontSizeToFitWidth = true
        rightLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        rightLabel.textAlignment = .Right
        rightLabel.textColor = UIColor.blackColor()
        rightLabel.shadowColor = UIColor.lightGrayColor()
        rightLabel.shadowOffset = CGSizeMake(0, 1)
        rightLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(rightLabel)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let footerPolygonViewDefaultPadding: CGFloat = 0.4
    let footerViewDefaultBackgroundColor: UIColor = UIColor.whiteColor()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let xOffset: CGFloat = self.padding
        let yOffset: CGFloat = 0
        let width: CGFloat = ceil(self.bounds.size.width * 0.5) - self.padding
        
        self.leftLabel.frame = CGRectMake(xOffset, yOffset, width, self.bounds.size.height)
        self.rightLabel.frame = CGRectMake(CGRectGetMaxX(leftLabel.frame), yOffset, width, self.bounds.size.height)
    }
    
}
