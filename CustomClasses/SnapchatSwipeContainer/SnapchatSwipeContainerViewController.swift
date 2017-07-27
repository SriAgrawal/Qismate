//
//  SnapchatSwipeContainerViewController.swift
//  Pods
//
//  Created by Jack Colley on 05/02/2017.
//
//

import UIKit

public class SnapchatSwipeContainerViewController: UIViewController, UIScrollViewDelegate {
    
    /// The left most UIViewController in the container
    public var leftVC: UIViewController!
    
    /// The middle UIViewController in the container - usually the one you want land on
    public var middleVC: UIViewController!
    
    /// The right most UIViewController in the container
    public var rightVC: UIViewController!
    
    /// Use this to set which screen you want to land on - defaults to the middle if not set
    public var initialContentOffset: CGPoint?
    
    /// The UIScrollView that will act as the container
    public var scrollView: UIScrollView!
    
    /// Should the container bounce when it is scrolled past its limits - default false
    public var shouldContainerBounce: Bool = false

    public override func viewDidLoad() {
        self.setupScrollView()
    }
    
    
    func setupScrollView() {
        // Create the UIScrollView and add it to the view
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = shouldContainerBounce
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        view.addSubview(scrollView)
        
        // Setting the content size for the UIScrollView
        let scrollHeight = 3 * scrollView.frame.height
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollHeight)
        
        // Setting the frames for our view controllers
        leftVC.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        middleVC.view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height)
        
        rightVC.view.frame = CGRect(x: 0, y: 2 * view.frame.height, width: view.frame.width, height: view.frame.height)
        
        scrollView.addSubview(leftVC.view)
        scrollView.addSubview(middleVC.view)
        scrollView.addSubview(rightVC.view)
        
        // Setting the contentOffset for the UIScrollView
        if let initialContentOffset = initialContentOffset {
            scrollView.contentOffset = initialContentOffset
        } else {
            let offset = CGPoint(x: middleVC.view.frame.origin.x, y: middleVC.view.frame.origin.y)
            scrollView.contentOffset = offset
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        if scrollView.contentOffset.y == 2*kWindowHeight() {
            let notificationName = Notification.Name("NotificationIdentifier")
            NotificationCenter.default.post(name: notificationName, object: nil)

        }
    }

}
