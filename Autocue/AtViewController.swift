//
//  AtViewController.swift
//  Autocue
//
//  Created by 老沙 on 2024/7/12.
//

import UIKit

class AtViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
}
