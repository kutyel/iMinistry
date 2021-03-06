//
//  iMinistryInformationView.swift
//  iMinistry
//
//  Created by Flavio Corpa on 13/04/15.
//  Copyright © 2015 Flavio Corpa. All rights reserved.
//

import UIKit

class iMinistryInformationView: UIView {
    
    var titleLabel = UILabel()
    var separatorView = UIView()
    var valueView = iMinistryValueView()
    
    // Constants
    
    let iMinistryValueViewPadding: CGFloat = 10.0
    let iMinistryValueViewSeparatorSize: CGFloat = 0.5
    let iMinistryValueViewTitleHeight: CGFloat = 50.0
    let iMinistryValueViewTitleWidth: CGFloat = 75.0
    let iMinistryValueViewDefaultAnimeDuration = 0.25
    
    // Colors
    
    let iMinistryValueViewSeparatorColor = UIColor.blackColor()
    let iMinistryValueViewTitleColor = UIColor.blackColor()
    let iMinistryValueViewShadowColor = UIColor.lightGrayColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.shadowColor = UIColor.lightGrayColor()
        titleLabel.shadowOffset = CGSizeMake(0, 1)
        titleLabel.textAlignment = .Left
        self.addSubview(titleLabel)
        
        separatorView.backgroundColor = UIColor.blackColor()
        self.addSubview(separatorView)
        self.addSubview(valueView)
        self.setHidden(true, animated: false)
    }

    // Position
    
    func valueViewRect() -> CGRect {
        var valueRect = CGRectZero
        valueRect.origin.x = iMinistryValueViewPadding
        valueRect.origin.y = iMinistryValueViewPadding + iMinistryValueViewTitleHeight
        valueRect.size.width = self.bounds.size.width - (iMinistryValueViewPadding * 2)
        valueRect.size.height = self.bounds.size.height - valueRect.origin.y - iMinistryValueViewPadding
        return valueRect
    }
    
    func titleViewForHidden(hidden: Bool) -> CGRect {
        var titleRect = CGRectZero
        titleRect.origin.x = iMinistryValueViewPadding
        titleRect.origin.y = hidden ? -iMinistryValueViewTitleHeight : iMinistryValueViewPadding
        titleRect.size.width = self.bounds.size.width - (iMinistryValueViewPadding * 2)
        titleRect.size.height = iMinistryValueViewTitleHeight
        return titleRect
    }
    
    func separatorViewForHidden(hidden: Bool) -> CGRect {
        var separator = CGRectZero
        separator.origin.x = iMinistryValueViewPadding
        separator.origin.y = iMinistryValueViewTitleHeight
        separator.size.width = self.bounds.size.width - (iMinistryValueViewPadding * 2)
        separator.size.height = iMinistryValueViewSeparatorSize
        if (hidden){
            separator.origin.x -= self.bounds.size.width
        }
        return separator
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    // Content
    
    func setTitle(title: String?) {
        titleLabel.text = title
        separatorView.hidden = !(title != nil)
    }
    
    func setValueText(value: String, unit: String) {
        valueView.valueLabel.text = value
        valueView.unitLabel.text = unit
        valueView.setNeedsLayout()
    }

    // Color
    
    func setTitleColor(color: UIColor) {
        titleLabel.textColor = color
        valueView.setNeedsDisplay()
    }
    
    func setValueAndUnitColor(color: UIColor) {
        valueView.valueLabel.textColor = color
        valueView.unitLabel.textColor = color
        valueView.setNeedsDisplay()
    }
    
    func setTextShadowColor(color: UIColor) {
        titleLabel.shadowColor = color
        valueView.valueLabel.shadowColor = color
        valueView.unitLabel.shadowColor = color
        valueView.setNeedsDisplay()
    }
    
    func setSeparatorColor(color: UIColor) {
        separatorView.backgroundColor = color
        self.setNeedsDisplay()
    }
    
    // Visibility
    
    func setHidden(hidden: Bool, animated: Bool) {
        if (animated) {
            if (hidden){
                UIView.animateWithDuration(iMinistryValueViewDefaultAnimeDuration, delay: 0.0, options: .BeginFromCurrentState, animations: {
                    self.titleLabel.alpha = 0
                    self.separatorView.alpha = 0
                    self.valueView.valueLabel.alpha = 0
                    self.valueView.unitLabel.alpha = 0
                }, completion: { finished in
                    self.titleLabel.frame = self.titleViewForHidden(true)
                    self.separatorView.frame = self.separatorViewForHidden(true)
                })
            }
            else {
                UIView.animateWithDuration(iMinistryValueViewDefaultAnimeDuration, delay: 0.0, options: .BeginFromCurrentState, animations: {
                    self.titleLabel.frame = self.titleViewForHidden(false)
                    self.separatorView.frame = self.separatorViewForHidden(false)
                    self.titleLabel.alpha = 1.0
                    self.separatorView.alpha = 1.0
                    self.valueView.valueLabel.alpha = 1.0
                    self.valueView.unitLabel.alpha = 1.0
                }, completion: nil)
            }
        }
        else {
            titleLabel.frame = titleViewForHidden(hidden)
            separatorView.frame = separatorViewForHidden(hidden)
            titleLabel.alpha = hidden ? 0.0 : 1.0
            separatorView.alpha = hidden ? 0.0 : 1.0
            valueView.valueLabel.alpha = hidden ? 0.0 : 1.0
            valueView.unitLabel.alpha = hidden ? 0.0 : 1.0
        }
    }
}
