//
//  iMinistryTooltipView.swift
//  iMinistry
//
//  Created by Flavio Corpa on 16/04/15.
//  Copyright © 2015 Flavio Corpa. All rights reserved.
//

import UIKit

class iMinistryTooltipView: UIView {

    var textLabel = UILabel()
    
    // Constants
    
    let iMinistryTooltipViewCornerRadius: CGFloat = 5.0
    let iMinistryTooltipViewDefaultWidth: CGFloat = 8.0
    let iMinistryTooltipViewDefaultHeight: CGFloat = 5.0

    override init(frame: CGRect) {
        super.init(frame: CGRectMake(0, 0, iMinistryTooltipViewDefaultWidth, iMinistryTooltipViewDefaultHeight))
        
        self.backgroundColor = UIColor.lightGrayColor()
        self.layer.cornerRadius = iMinistryTooltipViewCornerRadius
        
        textLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.textColor = UIColor.whiteColor()
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.numberOfLines = 1
        textLabel.textAlignment = .Center
        self.addSubview(textLabel)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setText(text: String){
        textLabel.text = text
        self.setNeedsLayout()
    }
    
    func setTooltipColor(color: UIColor){
        self.backgroundColor = color
        self.setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = self.bounds
    }
}
