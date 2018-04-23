//
//  FinishViewController.swift
//  PointVenture
//
//  Created by Sahil Ambardekar on 4/22/18.
//  Copyright © 2018 Sahil Ambardekar. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController {
    
    var delegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    @IBOutlet weak var otherPersonLabel: UILabel!
    @IBOutlet weak var userPoints: UILabel!
    @IBOutlet weak var otherPoints: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pointsTransferred = max(delegate.pointsUsed, delegate.pointsUsedByChallenger)
        let otherName = delegate.challenger.displayName
        if delegate.pointsUsed > delegate.pointsUsedByChallenger {
            titleLabel.text = "You Won!"
            summaryLabel.text = "\(otherName) was willing to use \(delegate.pointsUsedByChallenger!), but you used more"
            userPoints.text = "-\(pointsTransferred)"
            otherPoints.text = "+\(pointsTransferred)"
            if delegate.isInitiator {
                PointService.complete(gainUser: delegate.challenger.primaryKey!, loseUser: PointService.individual!.primaryKey!, points: pointsTransferred, completion: { (success) in
                    print("complete success " + String(success))
                })
            }
        } else if delegate.pointsUsedByChallenger > delegate.pointsUsed {
            titleLabel.text = "You Lost!"
            summaryLabel.text = "You were willing to use \(delegate.pointsUsed!), but \(otherName) used more"
            userPoints.text = "+\(pointsTransferred)"
            otherPoints.text = "-\(pointsTransferred)"
            if delegate.isInitiator {
                PointService.complete(gainUser: PointService.individual!.primaryKey!, loseUser: delegate.challenger.primaryKey!, points: pointsTransferred, completion: { (success) in
                    print("complete success " + String(success))
                })
            }
        } else {
            titleLabel.text = "Tie!"
            summaryLabel.text = "\(otherName) and you were both willing to use \(delegate.pointsUsedByChallenger!) points"
            userPoints.text = "+0"
            otherPoints.text = "+0"
        }
    }
    
    @IBAction func finish(_ sender: Any) {
        presentingViewController!.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    

}
