//
//  ViewController_y.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/08/19.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//
import UIKit
import SceneKit
import ARKit
import WebKit
import ARVideoKit

class ViewController_y: EyeTrackViewController_y {

    @IBOutlet var leftEyeView: UIView!
    @IBOutlet var rightEyeView: UIView!
    @IBOutlet weak var eyePositionIndicatorView: UIView!
    @IBOutlet weak var eyeTrackingPositionView: UIView!
    @IBOutlet weak var eyeTargetPositionXLabel: UILabel!
    @IBOutlet weak var eyeTargetPositionYLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!


    @IBAction func onClickRecord(_ sender: Any) {
        self.startRecord()
    }

    @IBAction func onClickStop(_ sender: Any) {
        self.stopRecord()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Disable sleep screen
        UIApplication.shared.isIdleTimerDisabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func updateViewWithUpdateAnchor() {
        // update indicator position
        self.eyePositionIndicatorView.transform = CGAffineTransform(translationX: eyeTrack.lookAtPosition.x, y: eyeTrack.lookAtPosition.y)

        if eyeTrack.lookAtPoint.x < 0 {
            self.eyeTargetPositionXLabel.text = "0"
        } else {
            self.eyeTargetPositionXLabel.text = "\(Int(round(eyeTrack.lookAtPoint.x)))"
        }

        if eyeTrack.lookAtPoint.y < 0 {
            self.eyeTargetPositionYLabel.text = "0"
        } else {
            self.eyeTargetPositionYLabel.text = "\(Int(round(eyeTrack.lookAtPoint.y)))"
        }

        // Update distance label value
        self.distanceLabel.text = "\(Int(round(eyeTrack.face.getDistanceToDevice() * 100))) cm"
    }
}


extension ViewController_y {


}


