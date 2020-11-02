//
//  TransitionController.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/11/01.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class TransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    // pushなら forward == true
    var forward = false
    
    // アニメーションの時間
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.4
    }
    
    // アニメーションの定義
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if self.forward {
            // Push時のアニメーション
            forwardTransition(transitionContext: transitionContext)
        } else {
            // Pop時のアニメーション
            backwardTransition(transitionContext: transitionContext)
        }
    }
    
    // Push時のアニメーション
    private func forwardTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }
        guard let containerView = transitionContext.containerView as UIView? else {
            return
        }
        
        // 遷移先のviewをaddSubviewする（fromVC.viewは最初からcontainerViewがsubviewとして持っている）
        containerView.addSubview(toVC.view)
        
        // addSubviewでレイアウトが崩れるため再レイアウトする
        toVC.view.layoutIfNeeded()
        
        // アニメーション用のimageViewを新しく作成する
        guard let sourceImageView = (fromVC as? SampleGalleryView)?.createImageView() else {
            return
        }
        guard let destinationImageView = (toVC as? DetailViewController)?.createImageView() else {
            return
        }
        
        // 遷移先のimageViewをaddSubviewする
        containerView.addSubview(sourceImageView)
        
        toVC.view.alpha = 0.0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.05, options: [.curveEaseIn, .curveEaseOut], animations: { () -> Void in
            
            // アニメーション開始
            // 遷移先のimageViewのframeとcontetModeを遷移元のimageViewに代入
            sourceImageView.frame = destinationImageView.frame
            sourceImageView.contentMode = destinationImageView.contentMode

            // cellのimageViewを非表示にする
            (fromVC as? SampleGalleryView)?.selectedImageView?.isHidden = true
            
            toVC.view.alpha = 1.0
            
            }) { (finished) -> Void in

                // アニメーション終了
                transitionContext.completeTransition(true)
        }
    }
    
    // Pop時のアニメーション
    private func backwardTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // Pushと逆のアニメーションを書く
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }
        guard let containerView = transitionContext.containerView as UIView? else {
            return
        }

        // 最初からcontainerViewがsubviewとして持っているfromVC.viewを削除
        fromVC.view.removeFromSuperview()
        
        // toView -> fromViewの順にaddSubview
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        guard let sourceImageView = (fromVC as? DetailViewController)?.createImageView() else {
            return
        }
        guard let destinationImageView = (toVC as? SampleGalleryView)?.createImageView() else {
            return
        }

        containerView.addSubview(sourceImageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.05, options: [.curveEaseIn, .curveEaseOut], animations: { () -> Void in

            sourceImageView.frame = destinationImageView.frame
            fromVC.view.alpha = 0.0
            
            }) { (finished) -> Void in
                
            sourceImageView.isHidden = true
                
            (toVC as? SampleGalleryView)?.selectedImageView?.isHidden = false

                transitionContext.completeTransition(true)
        }
    }
}
