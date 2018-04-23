//
//  ItemCollectionViewCell.swift
//  PointVenture
//
//  Created by Sahil Ambardekar on 4/17/18.
//  Copyright © 2018 Sahil Ambardekar. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    var shadowLayer: CAShapeLayer!
    var imageView: UIImageView!
    var nameLabel: UILabel!
    var subLabel: UILabel!
    var statusView: UIView!
    var nearby: Bool {
        get {
            return !statusView.isHidden
        }
        
        set {
            statusView.isHidden = !newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.layer.masksToBounds = false
        layer.masksToBounds = false
        contentView.clipsToBounds = false
        self.clipsToBounds = false
        
        let view = UIView(frame: bounds)
        view.backgroundColor = .white
        contentView.addSubview(view)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = false
        view.clipsToBounds = false
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 2
        view.layer.shadowPath = CGPath(rect: bounds, transform: nil)
        
        let view2 = UIView(frame: bounds)
        view2.layer.cornerRadius = 4
        view2.layer.masksToBounds = true
        view2.clipsToBounds = true
        
        let otherView = contentView.subviews[0]
        view2.addSubview(otherView)
        contentView.addSubview(view2)
        
        imageView = UIImageView(image: #imageLiteral(resourceName: "Empty Profile"))
        imageView.frame = CGRect(x: 15, y: 11, width: 46, height: 46)
        view2.addSubview(imageView)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.masksToBounds = true
        
        nameLabel = UILabel(frame: CGRect(x: 74, y: 12, width: 120, height: 21))
        nameLabel.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        nameLabel.text = "Dad"
        view2.addSubview(nameLabel)
        
        subLabel = UILabel(frame: CGRect(x: 74, y: 15 + 21, width: 120, height: 17))
        subLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        subLabel.textColor = UIColor.black.withAlphaComponent(0.33)
        subLabel.text = "451"
        view2.addSubview(subLabel)
        statusView = UIView(frame: CGRect(x: 301, y: 28, width: 14, height: 14))
        statusView.layer.cornerRadius = statusView.frame.width / 2
        statusView.layer.masksToBounds = true
        statusView.isHidden = true
        statusView.backgroundColor = UIColor(red:0.52, green:0.98, blue:0.52, alpha:1.00)
        view2.addSubview(statusView)
    }
}
