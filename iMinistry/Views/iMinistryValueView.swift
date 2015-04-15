//
//  iMinistryValueView.swift
//  iMinistry
//
//  Created by Flavio Corpa on 14/04/15.
//  Copyright (c) 2015 Flavio Corpa. All rights reserved.
//

import UIKit

class iMinistryValueView: UIView {
    
    var valueLabel = UILabel()
    var unitLabel = UILabel()
    
    let iMinistryValueInformationViewPadding: CGFloat = 10.0
    let iMinistryValueInformationViewValueColor = UIColor.blackColor()
    let iMinistryValueInformationViewUnitColor = UIColor.blackColor()
    let iMinistryValueInformationViewShadowColor = UIColor.lightGrayColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        valueLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 100)
        valueLabel.textColor = iMinistryValueInformationViewValueColor
        valueLabel.shadowColor = iMinistryValueInformationViewShadowColor
        valueLabel.shadowOffset = CGSizeMake(0, 1)
        valueLabel.backgroundColor = UIColor.clearColor()
        valueLabel.textAlignment = .Right
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.numberOfLines = 1
        self.addSubview(valueLabel)
        
        unitLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 70)
        unitLabel.textColor = iMinistryValueInformationViewUnitColor
        unitLabel.shadowColor = iMinistryValueInformationViewShadowColor
        unitLabel.shadowOffset = CGSizeMake(0, 1)
        unitLabel.backgroundColor = UIColor.clearColor()
        unitLabel.textAlignment = .Left
        unitLabel.adjustsFontSizeToFitWidth = true
        unitLabel.numberOfLines = 1
        self.addSubview(unitLabel)
    }
    
    // Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var valueSize = CGSizeZero
        if let textValue = valueLabel.text {
            valueSize = textValue.sizeWithAttributes([NSFontAttributeName:self.valueLabel.font])
        }
        var unitSize = CGSizeZero
        if let textUnit = unitLabel.text {
            unitSize = textUnit.sizeWithAttributes([NSFontAttributeName:self.unitLabel.font])
        }
        let xOffset = ceil((self.bounds.size.width - (valueSize.width + unitSize.width)) * 0.5)
        valueLabel.frame = CGRectMake(xOffset, ceil(self.bounds.size.height * 0.5) - ceil(valueSize.height * 0.5), valueSize.width, valueSize.height)
        unitLabel.frame = CGRectMake(CGRectGetMaxX(valueLabel.frame), ceil(self.bounds.size.height * 0.5) - ceil(unitSize.height * 0.5) + iMinistryValueInformationViewPadding, unitSize.width, unitSize.height)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
