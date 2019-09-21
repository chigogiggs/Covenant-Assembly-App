//
//  Slideintransition.swift
//  sidemenutest
//
//  Created by godwin anyaso on 14/08/2019.
//  Copyright © 2019 godwin anyaso. All rights reserved.
//

import UIKit

class Slideintransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewcontroller = transitionContext.viewController(forKey: .to) else {return}
        guard let fromViewcontroller = transitionContext.viewController(forKey: .from) else {return}
        
        let containerview = transitionContext.containerView
        let finalwidth = toViewcontroller.view.bounds.width * 0.7
        let finalheight = toViewcontroller.view.bounds.height
        
        if isPresenting{
            //add menu controller to container
            containerview.addSubview(toViewcontroller.view)
            toViewcontroller.view.frame = CGRect(x: -finalwidth, y: 0, width: finalwidth, height: finalheight)
        }
        
        //animate onto screen
        let transform = {
            toViewcontroller.view.transform = CGAffineTransform(translationX: finalwidth, y: 0)
            
        }
        //animate back off the screen
        let identity = {
            fromViewcontroller.view.transform = .identity
        }
        
        let duration = transitionDuration(using: transitionContext)
        let iscancelled = transitionContext.transitionWasCancelled
        
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identity()
        }){ (_) in
            transitionContext.completeTransition(!iscancelled)
            
        }
    }
    
    
}
