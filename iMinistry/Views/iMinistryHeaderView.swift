//
//  iMinistryHeaderView.swift
//  iMinistry
//
//  Created by Flavio Corpa on 08/04/15.
//  Copyright (c) 2015 Flavio Corpa. All rights reserved.
//

import UIKit

class iMinistryHeaderView: UIView {

    var titleLabel = UILabel()
    var separatorView = UIView()
    var subtitleLabel = UILabel()
    var separatorColor = UIColor.blackColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.shadowColor = UIColor.lightGrayColor()
        titleLabel.shadowOffset = CGSizeMake(0, 1)
        titleLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 1
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.textAlignment = .Center
        subtitleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        subtitleLabel.textColor = UIColor.blackColor()
        subtitleLabel.shadowColor = UIColor.lightGrayColor()
        subtitleLabel.shadowOffset = CGSizeMake(0, 1)
        subtitleLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(subtitleLabel)
        
        separatorView = UIView()
        separatorView.backgroundColor = headerViewDefaultSeparatorColor
        self.addSubview(separatorView)
    }

    let headerViewPadding: CGFloat = 10.0
    let headerViewSeparatorHeight: CGFloat = 0.5
    let headerViewDefaultSeparatorColor = UIColor.lightGrayColor()
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setSeparatorColor(color: UIColor) {
        separatorColor = color
        separatorView.backgroundColor = separatorColor
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var yOffset: CGFloat = 0
        let titleHeight = ceil(self.bounds.size.height * 0.5)
        let subTitleHeight = self.bounds.size.height - titleHeight - headerViewSeparatorHeight
        let xOffset: CGFloat = headerViewPadding
        
        self.titleLabel.frame = CGRectMake(xOffset, yOffset, self.bounds.size.width - (xOffset * 2), titleHeight)
        yOffset += self.titleLabel.frame.size.height
        self.separatorView.frame = CGRectMake(xOffset * 2, yOffset, self.bounds.size.width - (xOffset * 4), headerViewSeparatorHeight)
        yOffset += self.separatorView.frame.size.height
        self.subtitleLabel.frame = CGRectMake(xOffset, yOffset, self.bounds.size.width - (xOffset * 2), subTitleHeight)
    }

}
