//
//  UIViewController_Extension.swift
//  Autocue
//
//  Created by 老沙 on 2023/8/2.
//

import UIKit
import CoreFoundation

public extension UIViewController {
    
    /** Runtime关联Key*/
    private struct AssociatedKeys {
        static var rightText: String  = "kRightText"
        static var rightImage: String = "kRightImage"
    }
    
    /// 右上角文案（便于push提前设置）
    var rightText: String {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.rightText, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.rightText) as? String ?? ""
        }
    }
    
    /// 右上角图片（便于push提前设置）
    var rightImage: UIImage? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.rightImage, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.rightImage) as? UIImage
        }
    }
    
    /// 查找目标ViewController
    func findViewController<T: UIViewController>(with targetViewControllerClass: T.Type) -> T? {
        var currentResponder: UIResponder? = self.next
        while currentResponder != nil {
            if currentResponder?.classForCoder == targetViewControllerClass {
                return (currentResponder as? T)
            }
            currentResponder = currentResponder?.next
        }
        
        return nil
    }
    
    /// 当前的NavigationController
    static var currentNavigationController: UINavigationController? {
        let currentVController: UIViewController? = self.currentViewController
        var navgationController: UINavigationController? = currentVController?.navigationController
        var currentResponder: UIResponder? = currentVController?.next
        while navgationController == nil && currentResponder != nil {
            if let _navigationController = (currentResponder as? UIViewController)?.navigationController {
                navgationController = _navigationController
            }else{
                currentResponder = currentResponder?.next
            }
        }
        return navgationController
    }
    
    /// 当前的ViewController
    static var currentViewController: UIViewController? {
        var rootViewController: UIViewController?
        let textEffectsWindowClass: AnyClass? = NSClassFromString("UITextEffectsWindow")
        for window in UIApplication.shared.windows where !window.isHidden {
            if let _textEffectsWindowClass = textEffectsWindowClass, window.isKind(of: _textEffectsWindowClass) { continue }
            if let windowRootViewController = window.rootViewController {
                rootViewController = windowRootViewController
                break
            }
        }
        
        return self.topMost(of: rootViewController)
    }
    
    /// 查找目标ViewController的根视图
    ///
    /// 当前视图可能是UITabBarController、UINavigationController、UIPageViewController或者普通ViewController
    private static func topMost(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topMost(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topMost(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return self.topMost(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topMost(of: childViewController)
            }
        }
        
        return viewController
    }
}

