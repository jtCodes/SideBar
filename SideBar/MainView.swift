//
//  MainView.swift
//  SideBar
//
//  Created by J Tan on 10/22/18.
//  Copyright © 2018 J Tan. All rights reserved.
//

import UIKit

public class MainView: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate, UITableViewDelegate, SideBarViewDelegate {
    
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    
    public var yOffSet: CGFloat = 0.0
    public var navYOffSet: CGFloat = 0.0
    public var statusBarYOffSet: CGFloat = 0.0
    
    /**************************************************************************/
    // MARK: - initialize
    /**************************************************************************/
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navYOffSet = navigationController?.navigationBar.frame.size.height ?? 0.0
        statusBarYOffSet = UIApplication.shared.statusBarFrame.size.height
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        panGestureRecognizer?.delegate = self
        view.addGestureRecognizer(panGestureRecognizer!)
    }
    
    func sideBarDidSelectItem(item: String) {
        
    }
    
    func sideBarViewWillDisappear() {
        
    }
    
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        //    let direction = panGesture.direction(in: view)
        let translation = panGesture.translation(in: view)
        //   print(self.burgerView.frame.origin.x, self.view.frame.width - self.view.frame.width / 3)
        
        if panGesture.state == .began {
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            print(translation.x, self.view.frame.origin.x)
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if velocity.x <= -500 {
                
                let newViewController = SideBarView()
                newViewController.yOffSet = yOffSet
                newViewController.modalPresentationStyle = .overFullScreen
                newViewController.delegate = self
                self.present(newViewController, animated: false, completion: nil)
                //          UIView.animate(withDuration: 0.20, animations: {
                //            self.navigationController?.view.frame.origin.x = (self.navigationController?.view.frame.origin.x)! - 200
                //          }, completion: { (finished: Bool) in
                //          })
                
            }
        }
    }
    
}

