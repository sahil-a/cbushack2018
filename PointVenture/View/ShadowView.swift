//
//  ShadowView.swift
//  PointVenture
//
//  Created by Sahil Ambardekar on 4/18/18.
//  Copyright © 2018 Sahil Ambardekar. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .white
        layer.cornerRadius = 4
        layer.masksToBounds = false
        clipsToBounds = false
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
        layer.shadowPath = CGPath(rect: bounds, transform: nil)
    }

}
