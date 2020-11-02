//
//  TransitionNavigationController.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/11/01.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//
import UIKit

class TransitionNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        
        let transitionController = TransitionController()
        
        // pushとpopでは異なるアニメーションをさせるので条件を分ける
        switch operation {
        case .push:
            transitionController.forward = true
            return transitionController
        case .pop:
            transitionController.forward = false
            return transitionController
        default:
            break
        }
        return nil
    }
}
