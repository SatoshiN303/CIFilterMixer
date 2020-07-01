//
//  UIStoryboardExtension.swift
//  CIFilterMixer
//
//  Created by 佐藤 慎 on 2020/07/01.
//  Copyright © 2020 STSN. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    public var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    public static func makeInitialViewController(storyboardName: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    public static func makeViewController(storyboardName: String, withIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: withIdentifier)
    }
    
    public static func makeNavigationController(storyboardName: String, withIdentifier: String) -> UINavigationController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let nc = storyboard.instantiateViewController(withIdentifier: withIdentifier) as? UINavigationController else {
            fatalError()
        }
        return nc
    }
}
