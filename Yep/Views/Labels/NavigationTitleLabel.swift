//
//  NavigationTitleLabel.swift
//  
//
//  Created by NIX on 15/6/15.
//
//

import UIKit

class NavigationTitleLabel: UILabel {

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(title: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 30))

        text = title

        textAlignment = .Center
        font = UIFont.navigationBarTitleFont()
        textColor = UIColor.yepTintColor()
    }
}
